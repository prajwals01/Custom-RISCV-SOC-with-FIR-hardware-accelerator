/* verilator lint_off UNUSEDSIGNAL */
module reg_file(clk, reset, rs1, rs2, regwrite, rd, write_data, read_data1, read_data2);
    input clk, reset, regwrite;
    input [4:0] rs1, rs2, rd;
    input [31:0] write_data;
    output [31:0] read_data1, read_data2;
    
    integer k;
    reg [31:0] registers [31:0];

    // 1. POWER-ON INITIALIZATION
    initial begin
        for(k = 0; k < 32; k = k + 1)
            registers[k] = 32'b0;
            
        // NEW: Initialize Stack Pointer (x2) to top of RAM
        registers[2] = 32'd8188; 
    end

    // 2. SYNCHRONOUS REGISTER WRITE LOGIC (Gowin FPGA Synthesizable)
    always @(posedge clk) begin
        if(regwrite && rd != 5'b0) begin
            registers[rd] <= write_data;
        end
    end

    // 3. READ PORTS (x0 is always 0)
    assign read_data1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

endmodule