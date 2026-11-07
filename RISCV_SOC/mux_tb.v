`timescale 1ns/1ps

module mux_tb;

reg sel1, sel2, sel3;
reg [31:0] A1, B1, A2, B2, A3, B3;

wire [31:0] mux1_out, mux2_out, mux3_out;

// Instantiate MUX modules
mux1 m1(sel1, A1, B1, mux1_out);
mux2 m2(sel2, A2, B2, mux2_out);
mux3 m3(sel3, A3, B3, mux3_out);

initial begin
    // Dump file for GTKWave
    $dumpfile("mux.vcd");
    $dumpvars(0, mux_tb);

    // Initialize inputs
    sel1 = 0; sel2 = 0; sel3 = 0;
    A1 = 32'hAAAAAAAA; B1 = 32'hBBBBBBBB;
    A2 = 32'h11111111; B2 = 32'h22222222;
    A3 = 32'h12345678; B3 = 32'h87654321;

    #10;

    // Case 1: Select A inputs
    sel1 = 0; sel2 = 0; sel3 = 0;
    #10;

    // Case 2: Select B inputs
    sel1 = 1; sel2 = 1; sel3 = 1;
    #10;

    // Mixed cases
    sel1 = 0; sel2 = 1; sel3 = 0;
    #10;

    sel1 = 1; sel2 = 0; sel3 = 1;
    #10;

    $finish;
end

endmodule