`timescale 1ns/1ps

module alu_unit_tb;

reg [31:0] A, B;
reg [3:0] control_in;
wire [31:0] ALU_result;
wire zero;

// Instantiate the ALU
alu_unit uut (
    .A(A),
    .B(B),
    .control_in(control_in),
    .ALU_result(ALU_result),
    .zero(zero)
);

initial begin
    // Dump file for GTKWave
    $dumpfile("alu_unit.vcd");
    $dumpvars(0, alu_unit_tb);

    // Test 1: AND operation
    A = 32'd10; B = 32'd5; control_in = 4'b0000;
    #10;

    // Test 2: OR operation
    A = 32'd10; B = 32'd5; control_in = 4'b0001;
    #10;

    // Test 3: ADD operation
    A = 32'd10; B = 32'd5; control_in = 4'b0010;
    #10;

    // Test 4: SUB operation (not equal)
    A = 32'd10; B = 32'd5; control_in = 4'b0110;
    #10;

    // Test 5: SUB operation (equal case → zero = 1)
    A = 32'd5; B = 32'd5; control_in = 4'b0110;
    #10;

    // Test 6: Different values
    A = 32'd20; B = 32'd15; control_in = 4'b0010;
    #10;

    $finish;
end

endmodule