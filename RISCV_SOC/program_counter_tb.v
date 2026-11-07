`timescale 1ns/1ps

module pc_tb;

reg clk;
reg reset;
reg [31:0] pc_in;
wire [31:0] pc_out;

// Instantiate your module
program_counter uut (
    .clk(clk),
    .reset(reset),
    .pc_in(pc_in),
    .pc_out(pc_out)
);

// 🔹 Clock generation (10ns period)
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    reset = 1;
    pc_in = 0;

    // Hold reset
    #10;
    reset = 0;

    // Apply different inputs
    #10 pc_in = 4;
    #10 pc_in = 8;
    #10 pc_in = 12;
    #10 pc_in = 16;
    #10 pc_in = 20;

    #20;
    $finish;
end

// Monitor
initial begin
    $monitor("Time=%0t | reset=%b | pc_in=%d | pc_out=%d",
              $time, reset, pc_in, pc_out);
end

// Dump for GTKWave
initial begin
    $dumpfile("pc.vcd");
    $dumpvars(0, pc_tb);
end

endmodule