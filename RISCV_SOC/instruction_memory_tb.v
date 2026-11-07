`timescale 1ns/1ps

module imem_tb;

reg clk;
reg reset;
reg [31:0] read_address;
wire [31:0] instruction_out;

// Instantiate your module
instruction_mem uut (
    .clk(clk),
    .reset(reset),
    .read_address(read_address),
    .instruction_out(instruction_out)
);

// 🔹 Clock generation
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    reset = 1;
    read_address = 0;

    // Apply reset
    #10;
    reset = 0;

    // 🔹 Load instructions manually into memory
    uut.I_mem[0] = 32'h11111111;
    uut.I_mem[1] = 32'h22222222;
    uut.I_mem[2] = 32'h33333333;
    uut.I_mem[3] = 32'h44444444;

    // 🔹 Read using byte addresses (like PC)
    #10 read_address = 0;    // I_mem[0]
    #10 read_address = 4;    // I_mem[1]
    #10 read_address = 8;    // I_mem[2]
    #10 read_address = 12;   // I_mem[3]

    #20;
    $finish;
end

// Monitor output
initial begin
    $monitor("Time=%0t | Addr=%d | Instruction=%h",
              $time, read_address, instruction_out);
end

// Dump waveform
initial begin
    $dumpfile("imem.vcd");
    $dumpvars(0, imem_tb);
end

endmodule