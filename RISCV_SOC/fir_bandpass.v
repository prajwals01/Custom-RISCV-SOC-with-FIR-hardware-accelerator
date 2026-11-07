module fir_bandpass (
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire signed [31:0] data_in,
    input wire status_read_ack, // NEW: pulses when the CPU reads the status/FIR_STATUS register
    output reg valid_out,
    output reg signed [31:0] data_out
);

parameter TAPS = 31;
integer i;

reg signed [31:0] shift_reg [0:TAPS-1];

// Symmetric bandpass coefficients (fixed-point scaled)
wire signed [31:0] coeff [0:TAPS-1];
assign coeff[0]  = -32'sd220;  assign coeff[30] = -32'sd220;
assign coeff[1]  = -32'sd251;  assign coeff[29] = -32'sd251;
assign coeff[2]  = -32'sd315;  assign coeff[28] = -32'sd315;
assign coeff[3]  = -32'sd379;  assign coeff[27] = -32'sd379;
assign coeff[4]  = -32'sd388;  assign coeff[26] = -32'sd388;
assign coeff[5]  = -32'sd272;  assign coeff[25] = -32'sd272;
assign coeff[6]  =  32'sd38;   assign coeff[24] =  32'sd38;
assign coeff[7]  =  32'sd591;  assign coeff[23] =  32'sd591;
assign coeff[8]  =  32'sd1408; assign coeff[22] =  32'sd1408;
assign coeff[9]  =  32'sd2462; assign coeff[21] =  32'sd2462;
assign coeff[10] =  32'sd3684; assign coeff[20] =  32'sd3684;
assign coeff[11] =  32'sd4703; assign coeff[19] =  32'sd4703;
assign coeff[12] =  32'sd5277; assign coeff[18] =  32'sd5277;
assign coeff[13] =  32'sd5381; assign coeff[17] =  32'sd5381;
assign coeff[14] =  32'sd5100; assign coeff[16] =  32'sd5100;
assign coeff[15] =  32'sd4608; // Center tap

// Continuous combinational MAC product-sum
wire signed [63:0] mac_sum =
    ($signed(data_in)       * $signed(coeff[0]))  +
    ($signed(shift_reg[0])  * $signed(coeff[1]))  +
    ($signed(shift_reg[1])  * $signed(coeff[2]))  +
    ($signed(shift_reg[2])  * $signed(coeff[3]))  +
    ($signed(shift_reg[3])  * $signed(coeff[4]))  +
    ($signed(shift_reg[4])  * $signed(coeff[5]))  +
    ($signed(shift_reg[5])  * $signed(coeff[6]))  +
    ($signed(shift_reg[6])  * $signed(coeff[7]))  +
    ($signed(shift_reg[7])  * $signed(coeff[8]))  +
    ($signed(shift_reg[8])  * $signed(coeff[9]))  +
    ($signed(shift_reg[9])  * $signed(coeff[10])) +
    ($signed(shift_reg[10]) * $signed(coeff[11])) +
    ($signed(shift_reg[11]) * $signed(coeff[12])) +
    ($signed(shift_reg[12]) * $signed(coeff[13])) +
    ($signed(shift_reg[13]) * $signed(coeff[14])) +
    ($signed(shift_reg[14]) * $signed(coeff[15])) +
    ($signed(shift_reg[15]) * $signed(coeff[16])) +
    ($signed(shift_reg[16]) * $signed(coeff[17])) +
    ($signed(shift_reg[17]) * $signed(coeff[18])) +
    ($signed(shift_reg[18]) * $signed(coeff[19])) +
    ($signed(shift_reg[19]) * $signed(coeff[20])) +
    ($signed(shift_reg[20]) * $signed(coeff[21])) +
    ($signed(shift_reg[21]) * $signed(coeff[22])) +
    ($signed(shift_reg[22]) * $signed(coeff[23])) +
    ($signed(shift_reg[23]) * $signed(coeff[24])) +
    ($signed(shift_reg[24]) * $signed(coeff[25])) +
    ($signed(shift_reg[25]) * $signed(coeff[26])) +
    ($signed(shift_reg[26]) * $signed(coeff[27])) +
    ($signed(shift_reg[27]) * $signed(coeff[28])) +
    ($signed(shift_reg[28]) * $signed(coeff[29])) +
    ($signed(shift_reg[29]) * $signed(coeff[30]));

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < TAPS; i = i + 1)
            shift_reg[i] <= 32'sd0;
        data_out  <= 32'sd0;
        valid_out <= 1'b0;
    end
    else if (valid_in) begin
        // Shift register update
        for (i = TAPS-1; i > 0; i = i - 1)
            shift_reg[i] <= shift_reg[i-1];
        shift_reg[0] <= data_in;

        // Truncate fixed-point result (Q13 scale)
        data_out  <= mac_sum[44:13];
        valid_out <= 1'b1;
    end
    else if (status_read_ack) begin
        valid_out <= 1'b0;
    end
end
endmodule

