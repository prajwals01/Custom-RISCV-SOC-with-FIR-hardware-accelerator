/* verilator lint_off UNUSEDSIGNAL */
module immgen(opcode,instruction,immext);
input [6:0] opcode;
input[31:0] instruction;
output reg [31:0] immext;
always @ (*)
begin
    case(opcode)
        // I-type (lw)
        7'b0000011: immext = {{20{instruction[31]}}, instruction[31:20]};
        
        // I-type ALU (addi, ori, etc.) - THIS WAS MISSING!
        7'b0010011: immext = {{20{instruction[31]}}, instruction[31:20]};
        
        // S-type (sw)
        7'b0100011: immext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        
        // B-type (branch)
        7'b1100011: immext = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

        7'b1101111: immext = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

        // U-type (lui) - Unlocks large numbers and high memory addresses!
        7'b0110111: immext = {instruction[31:12], 12'b0};
        
        // Default to prevent latches and 'x' states
        default: immext = 32'b0;
    endcase
end
endmodule