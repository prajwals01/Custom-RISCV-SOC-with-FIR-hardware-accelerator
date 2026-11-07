`timescale 1ns/1ps

module immgen_tb;

reg [6:0] opcode;
reg [31:0] instruction;
wire [31:0] immext;

// Instantiate DUT (Device Under Test)
immgen uut (
    .opcode(opcode),
    .instruction(instruction),
    .immext(immext)
);

initial begin
    $dumpfile("immgen.vcd");   // for GTKWave
    $dumpvars(0, immgen_tb);

    // ----------- I-TYPE (LOAD) -----------
    // Example: imm = 0x00A (10)
    opcode = 7'b0000011;
    instruction = 32'b000000000101_00000_010_00001_0000011;
    #10;

    // ----------- S-TYPE (STORE) ----------
    // imm = split across [31:25] and [11:7]
    opcode = 7'b0100011;
    instruction = 32'b0000000_00010_00001_010_00101_0100011;
    #10;

    // ----------- B-TYPE (BRANCH) ---------
    opcode = 7'b1100011;
    instruction = 32'b0000000_00010_00001_000_00100_1100011;
    #10;

    // ----------- NEGATIVE IMM (I-TYPE) ---
    opcode = 7'b0000011;
    instruction = 32'b111111111111_00000_010_00001_0000011;
    #10;

    $finish;
end

endmodule