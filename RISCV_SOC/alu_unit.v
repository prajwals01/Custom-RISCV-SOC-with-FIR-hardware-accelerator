module alu_unit(A,B,control_in,ALU_result,zero);

input [31:0] A,B;
input [3:0] control_in;
output reg zero;
output reg [31:0] ALU_result;

always @(*) begin
    case(control_in)
        4'b0000: ALU_result = A & B;
        4'b0001: ALU_result = A | B;
        4'b0010: ALU_result = A + B;
        4'b0110: ALU_result = A - B;
        default: ALU_result = 32'b0;
    endcase

    zero = (ALU_result == 0);
end

endmodule