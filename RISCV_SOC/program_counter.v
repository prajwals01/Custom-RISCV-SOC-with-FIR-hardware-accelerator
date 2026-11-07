module program_counter(clk,reset,pc_in,pc_out);
input [31:0] pc_in;
input clk,reset;
output reg [31:0] pc_out;

always @(posedge clk or posedge reset) begin
    if(reset)
    pc_out<=32'b0;
    else
    pc_out<=pc_in;
end
endmodule

module pcplus4(frompc,nextopc);
input [31:0] frompc;
output [31:0] nextopc;
assign nextopc = 4 + frompc;
endmodule

