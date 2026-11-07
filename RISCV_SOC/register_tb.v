`timescale 1ns/1ps

module reg_file_tb;

reg clk, reset, regwrite;
reg [4:0] rs1, rs2, rd;
reg [31:0] write_data;
wire [31:0] read_data1, read_data2;

// Instantiate DUT
reg_file uut (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .regwrite(regwrite),
    .rd(rd),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

initial begin
    // 🔴 Dump file for GTKWave
    $dumpfile("regfile.vcd");
    $dumpvars(0, reg_file_tb);

    // Initialize signals
    clk = 0;
    reset = 1;
    regwrite = 0;
    rs1 = 0;
    rs2 = 0;
    rd  = 0;
    write_data = 0;

    // -------------------------
    // RESET
    // -------------------------
    #10;
    reset = 0;

    // -------------------------
    // WRITE: R5 = 100
    // -------------------------
    #10;
    regwrite = 0;
    rs1 = 5;
    rs2 = 6;

    #10;
    regwrite = 0;
    rs1 = 3;
    rs2 = 2;

    #10;

    // -------------------------
    // READ: R5
    // -------------------------
    regwrite = 0;
    rs1 = 5;
    rs2 = 0;

    #10;

    // -------------------------
    // WRITE: R10 = 200
    // -------------------------
    regwrite = 1;
    rd = 10;
    write_data = 32'd200;

    #10;

    // -------------------------
    // READ: R5 and R10
    // -------------------------
    regwrite = 0;
    rs1 = 5;
    rs2 = 10;

    #10;

    // -------------------------
    // WRITE: R0 = 999 (edge case)
    // -------------------------
    regwrite = 1;
    rd = 0;
    write_data = 32'd999;

    #10;

    // READ: R0 and R5
    regwrite = 0;
    rs1 = 0;
    rs2 = 5;

    #20;

    $finish;
end

endmodule