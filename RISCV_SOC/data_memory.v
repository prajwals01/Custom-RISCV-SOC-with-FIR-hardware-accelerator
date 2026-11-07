/* verilator lint_off UNUSEDSIGNAL */
module data_memory(
    input clk,
    input reset,
    input memwrite,
    input memread,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] memdata_out  // Removed 'reg' so we can use assign
);

reg [31:0] D_memory [0:2047]; // <-- Change this line!
integer k;

// Expanded to 9 bits to support 512 memory slots
wire [10:0] word_addr;
// Drop the bottom 2 bits for byte-to-word translation
assign word_addr = address[12:2];

// INSTANT (ASYNCHRONOUS) READ: Data flows out immediately!
assign memdata_out = memread ? D_memory[word_addr] : 32'b0;

// SYNCHRONOUS WRITE: Writes still happen safely on the clock edge
always @(posedge clk)
begin
    if (memwrite)
        D_memory[word_addr] <= write_data;
end

// Initialize the RAM and load the sensor data
// Initialize the RAM and load the sensor data
initial begin
    // Update the loop to clear all 2048 slots
    for (k = 0; k < 2048; k = k + 1) begin
        D_memory[k] = 32'b0;
    end
    $readmemh("noisy_ppg.hex", D_memory);
end
endmodule
