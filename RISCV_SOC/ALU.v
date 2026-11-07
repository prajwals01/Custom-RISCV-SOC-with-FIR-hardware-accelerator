module alu(A,B,ALUControl,result,Z,N,V,C);

input [31:0] A,B;
input [2:0] ALUControl;
output [31:0] result;
output Z,N,V,C;
wire [31:0] a_and_b;
wire [31:0] a_or_b;
wire [31:0] not_b;
wire [31:0] mux_1;
wire[31:0] sum;
wire [31:0] mux_2;
wire[31:0] slt;
wire cout;
assign a_and_b= A & B;
assign a_or_b=A|B;
assign  not_b=~B;
assign mux_1=(ALUControl [0]==1'b0) ? B: not_b; //To select Add or subtract based on last bit
assign {cout,sum}=A + mux_1 + ALUControl[0]; //Subtraction is done by A+(2's complement of B)
assign slt={31'b0000000000000000000000000000000, sum[31]};
assign mux_2=(ALUControl[2:0]==3'b000) ? sum:
             (ALUControl[2:0]==3'b001) ? sum:
             (ALUControl[2:0]==3'b010) ? a_and_b:
             (ALUControl[2:0]==3'b011) ? a_or_b:    
             (ALUControl[2:0]==3'b101) ? slt:32'h00000000;

assign result=mux_2;

assign Z=&(~result);

assign N=result[31];

assign C=cout &(~ALUControl[1]);

assign V=(~ALUControl[1]) & (A[31] ^ sum[31]) & (~(A[31] ^ B[31] ^ ALUControl[0]));

endmodule
