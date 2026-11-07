// Dedicated branch comparator.
// Fixes the bug where and_logic(branch, ~zero_top) forced EVERY branch
// opcode to mean "branch if not equal", regardless of the real funct3
// (beq/bne/blt/bge/bltu/bgeu). Branches always compare two REGISTER
// operands (rs1, rs2) per the RISC-V spec, so this reads rd1_top/rd2_top
// directly instead of going through the ALU/immediate mux.
module branch_comp(
    input branch,
    input [2:0] funct3,
    input signed [31:0] rs1_data,
    input signed [31:0] rs2_data,
    output reg take_branch
);

always @(*) begin
    if (!branch) begin
        take_branch = 1'b0;
    end else begin
        case (funct3)
            3'b000: take_branch = (rs1_data == rs2_data);                        // BEQ
            3'b001: take_branch = (rs1_data != rs2_data);                        // BNE
            3'b100: take_branch = (rs1_data <  rs2_data);                        // BLT  (signed)
            3'b101: take_branch = (rs1_data >= rs2_data);                        // BGE  (signed)
            3'b110: take_branch = ($unsigned(rs1_data) <  $unsigned(rs2_data));  // BLTU
            3'b111: take_branch = ($unsigned(rs1_data) >= $unsigned(rs2_data));  // BGEU
            default: take_branch = 1'b0;
        endcase
    end
end

endmodule
