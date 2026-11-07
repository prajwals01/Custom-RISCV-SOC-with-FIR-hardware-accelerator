`timescale 1ns/1ps

module control_unit_tb;

reg [6:0] instruction;
wire branch, memread, memtoreg, memwrite, alusrc, regwrite;
wire [1:0] aluop;

// Instantiate DUT
control_unit uut (
    .instruction(instruction),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .regwrite(regwrite),
    .aluop(aluop)
);

initial begin
    $dumpfile("control_unit.vcd");
    $dumpvars(0, control_unit_tb);

    // Test R-type
    instruction = 7'b0110011;
    #10;

    // Test Load (lw)
    instruction = 7'b0000011;
    #10;

    // Test Store (sw)
    instruction = 7'b0100011;
    #10;

    // Test Branch (beq)
    instruction = 7'b1100011;
    #10;

    // Test default
    instruction = 7'b1111111;
    #10;

    $finish;
end

initial begin
    $monitor("Time=%0t | Instr=%b | ALUSrc=%b MemtoReg=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b ALUOp=%b",
        $time, instruction, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop);
end

endmodule