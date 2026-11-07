`timescale 1ns/1ps

module alu_control_tb;

reg fun7;
reg [2:0] fun3;
reg [1:0] ALUop;
wire [3:0] control_out;

alu_control uut (
    .ALUop(ALUop),
    .fun7(fun7),
    .fun3(fun3),
    .control_out(control_out)
);

initial begin
    // Dump for GTKWave
    $dumpfile("alu_control.vcd");
    $dumpvars(0, alu_control_tb);

    $display("ALUop fun7 fun3 | control_out");
    $display("--------------------------------");

    ALUop = 2'b00; fun7 = 0; fun3 = 3'b000; #10;
    ALUop = 2'b01; fun7 = 0; fun3 = 3'b000; #10;
    ALUop = 2'b10; fun7 = 0; fun3 = 3'b000; #10;
    ALUop = 2'b10; fun7 = 1; fun3 = 3'b000; #10;
    ALUop = 2'b10; fun7 = 0; fun3 = 3'b111; #10;
    ALUop = 2'b10; fun7 = 0; fun3 = 3'b110; #10;

    $finish;
end

endmodule