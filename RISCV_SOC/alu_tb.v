

module alu_tb;

reg [31:0] A, B;
reg [2:0] ALUControl;

wire [31:0] result;
wire Z, N, V, C;

// Instantiate ALU
alu uut (
    .A(A),
    .B(B),
    .ALUControl(ALUControl),
    .result(result),
    .Z(Z),
    .N(N),
    .V(V),
    .C(C)
);

initial begin
    $dumpfile("alu.vcd");   // waveform file
    $dumpvars(0, alu_tb);

    // Test 1: ADD
    A = 10; B = 5; ALUControl = 3'b000;
    #10;

    // Test 2: SUB (A - B)
    A = 10; B = 5; ALUControl = 3'b001;
    #10;

    // Test 3: AND
    A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 3'b010;
    #10;

    // Test 4: OR
    A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 3'b011;
    #10;

    // Test 5: SLT (set less than)
    A = 5; B = 10; ALUControl = 3'b101;
    #10;

    // Test 6: Zero result
    A = 5; B = 5; ALUControl = 3'b001;
    #10;

    // Test 7: Negative result
    A = 5; B = 10; ALUControl = 3'b001;
    #10;

    // Test 8: Overflow check
    A = 32'h7FFFFFFF; B = 1; ALUControl = 3'b000;
    #10;

    $finish;
end
endmodule