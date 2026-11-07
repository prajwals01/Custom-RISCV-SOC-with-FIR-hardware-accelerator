/* verilator lint_off UNUSEDSIGNAL */
module instruction_mem(clk, reset, read_address, instruction_out);

input clk, reset;
input [31:0] read_address;
output reg [31:0] instruction_out;

reg [31:0] I_mem [0:63];
integer k;

// Paste this right before your always @(*) block
    initial begin
        for (k = 0; k < 64; k = k + 1)
            I_mem[k] = 32'b0;
            
        // Load the software directly inside the module
        $readmemh("program.hex", I_mem);
    end



always @(*) begin
    if (reset)
        instruction_out = 32'b0;
    else
        instruction_out = I_mem[read_address[7:2]];
end

endmodule