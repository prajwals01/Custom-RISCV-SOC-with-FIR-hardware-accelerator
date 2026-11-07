`timescale 1ns/1ps

module data_memory_tb;

reg clk, reset, memwrite, memread;
reg [31:0] address, write_data;
wire [31:0] memdata_out;

// Instantiate your memory
data_memory uut (
    .clk(clk),
    .reset(reset),
    .memwrite(memwrite),
    .memread(memread),
    .read_address(address),
    .write_data(write_data),
    .memdata_out(memdata_out)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

initial
begin
    // Initialize signals
    clk = 0;
    reset = 1;
    memwrite = 0;
    memread = 0;
    address = 0;
    write_data = 0;

    // Dump file for GTKWave
    $dumpfile("data_memory.vcd");
    $dumpvars(0, data_memory_tb);

    // -------------------------
    // STEP 1: Reset memory
    // -------------------------
    #10;
    reset = 0;

    // -------------------------
    // STEP 2: Write data
    // -------------------------
    #10;
    memwrite = 1;
    address = 5;
    write_data = 32'hA5A5A5A5;

    #10;
    memwrite = 0;

    // -------------------------
    // STEP 3: Read data
    // -------------------------
    #10;
    memread = 1;
    address = 5;

    #10;
    memread = 0;

    // -------------------------
    // STEP 4: Another write
    // -------------------------
    #10;
    memwrite = 1;
    address = 10;
    write_data = 32'h12345678;

    #10;
    memwrite = 0;

    // -------------------------
    // STEP 5: Read again
    // -------------------------
    #10;
    memread = 1;
    address = 10;

    #10;
    memread = 0;

    // Finish simulation
    #20;
    $finish;
end

endmodule