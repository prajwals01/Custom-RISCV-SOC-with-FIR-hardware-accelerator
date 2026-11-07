module top(clk, reset, out_data);
input clk, reset;
output [31:0] out_data;
wire [31:0] pc_top,instruction_top,rd1_top,rd2_top,immext_top,mux1_top,sum_out_top,nextopc_top,pcin_top,address_top,memdata_top,writeback_top;
wire regwrite_top,ALUsrc_top,branch_top,jump_top,memtoreg_top,memwrite_top,memread_top;
wire[1:0] ALUop_top;
wire[3:0] control_top;

program_counter pc(.clk(clk),.reset(reset),.pc_in(pcin_top),.pc_out(pc_top));

pcplus4 pc_adder(.frompc(pc_top),.nextopc(nextopc_top));

instruction_mem  inst_mem(.clk(clk),.reset(reset),.read_address(pc_top),.instruction_out(instruction_top));

reg_file reg_file(.clk(clk),.reset(reset),.rs1(instruction_top[19:15]),.rs2(instruction_top[24:20]),.regwrite(regwrite_top),.rd((instruction_top[11:7])),.write_data(writeback_top),.read_data1(rd1_top),.read_data2(rd2_top));

immgen immgen(.opcode(instruction_top[6:0]),.instruction(instruction_top),.immext(immext_top));

control_unit control_unit(.opcode(instruction_top[6:0]),.branch(branch_top),.jump(jump_top),.memread(memread_top),.memtoreg(memtoreg_top),.aluop(ALUop_top),.memwrite(memwrite_top),.alusrc(ALUsrc_top),.regwrite(regwrite_top));

alu_control alu_control(.ALUop(ALUop_top),.fun7(instruction_top[30]),.fun3(instruction_top[14:12]),.control_out(control_top));

alu_unit alu(.A(rd1_top),.B(mux1_top),.control_in(control_top),.ALU_result(address_top),.zero());

mux1 ALU_mux(.sel1(ALUsrc_top),.A1(rd2_top),.B1(immext_top),.mux1_out(mux1_top));

adder adder(.in_1(pc_top),.in_2(immext_top),.sum_out(sum_out_top));

// FIX: dedicated comparator reading rs1/rs2 directly and decoding funct3,
// instead of and_logic(branch, ~zero_top) which hardwired every branch
// opcode to mean "not equal" regardless of beq/bne/blt/bge/etc.
wire take_branch;
branch_comp branch_cmp (
    .branch(branch_top),
    .funct3(instruction_top[14:12]),
    .rs1_data(rd1_top),
    .rs2_data(rd2_top),
    .take_branch(take_branch)
);

// FIX: PC redirect now happens on a real taken-branch OR an unconditional
// jump (jal) - jal is no longer routed through the ALU-zero-flag hack, so
// it can no longer silently fail to jump.
wire pc_redirect = take_branch | jump_top;

mux2 adder_mux(.sel2(pc_redirect),.A2(nextopc_top),.B2(sum_out_top),.mux2_out(pcin_top));

wire is_fir_addr   = (address_top == 32'hFFFFFFFC); // -4
wire is_fir_status = (address_top == 32'hFFFFFFF8); // -8

wire fir_valid_in = is_fir_addr & memwrite_top;

// FIX: acknowledge strobe so the FIR module knows exactly when software has
// consumed the status flag, instead of guessing based on a fixed pulse width.
wire status_read_ack = is_fir_status & memread_top;

wire fir_valid_out;
wire signed [31:0] fir_data_out;

fir_bandpass bio_filter (
    .clk(clk),
    .reset(reset),
    .valid_in(fir_valid_in),
    .data_in(rd2_top),
    .status_read_ack(status_read_ack),
    .valid_out(fir_valid_out),
    .data_out(fir_data_out)
);

wire [31:0] dmem_raw_out;

data_memory data_mem (
    .clk(clk),
    .reset(reset),
    .memwrite(memwrite_top & ~is_fir_addr & ~is_fir_status),
    .memread(memread_top),
    .address(address_top),
    .write_data(rd2_top),
    .memdata_out(dmem_raw_out)
);

assign memdata_top = is_fir_addr   ? fir_data_out :
                     is_fir_status ? {31'b0, fir_valid_out} :
                     dmem_raw_out;

assign out_data = memdata_top;

// FIX: writeback now has three sources, not two - jal must write PC+4
// (nextopc_top), not the ALU result. Previously jal fell through mux3's
// memtoreg=0 path and wrote whatever garbage the ALU computed from the
// jal immediate bits reinterpreted as register operands.
assign writeback_top = jump_top      ? nextopc_top :
                       memtoreg_top ? memdata_top  :
                                      address_top;

// Add to top.v for one simulation run only
always @(posedge clk) begin
    if (fir_valid_in)
        $display("T=%0t FIR INPUT  data=%0d", $time, rd2_top);
    if (fir_valid_out && status_read_ack)
        $display("T=%0t FIR OUTPUT read, data=%0d", $time, fir_data_out);
    if (status_read_ack)
        $display("T=%0t STATUS READ valid_out=%0b", $time, fir_valid_out);
end

endmodule
