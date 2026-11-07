module alu_control(ALUop, fun7, fun3, control_out);

input fun7;
input [2:0] fun3;
input [1:0] ALUop;
output reg [3:0] control_out;

always @(*)
begin
    case ({ALUop, fun7, fun3})

        // lw, sw, addi
        6'b00_0_000: control_out = 4'b0010; // ADD

        // branch
        6'b01_0_000: control_out = 4'b0110; // SUB

        // R-type
        6'b10_0_000: control_out = 4'b0010; // ADD
        6'b10_1_000: control_out = 4'b0110; // SUB
        6'b10_0_111: control_out = 4'b0000; // AND
        6'b10_0_110: control_out = 4'b0001; // OR

        // I-type OR (ori)
        6'b00_0_110: control_out = 4'b0001; // OR

        default: control_out = 4'b0010; // SAFE DEFAULT (ADD)

    endcase
end

endmodule