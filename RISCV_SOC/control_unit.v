module control_unit(
    input [6:0] opcode,
    output reg branch,   // real conditional branches only (opcode 1100011)
    output reg jump,     // unconditional jumps (JAL) - NEW, separate from branch
    output reg memread,
    output reg memtoreg,
    output reg memwrite,
    output reg alusrc,
    output reg regwrite,
    output reg [1:0] aluop
);

always @(*)
begin
    case(opcode)

    // R-type (add, sub, and, or)
    7'b0110011:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 1;
        memread  = 0;
        memwrite = 0;
        branch   = 0;
        jump     = 0;
        aluop    = 2'b10;
    end

    // lw
    7'b0000011:
    begin
        alusrc   = 1;
        memtoreg = 1;
        regwrite = 1;
        memread  = 1;
        memwrite = 0;
        branch   = 0;
        jump     = 0;
        aluop    = 2'b00;
    end

    // sw
    7'b0100011:
    begin
        alusrc   = 1;
        memtoreg = 0;
        regwrite = 0;
        memread  = 0;
        memwrite = 1;
        branch   = 0;
        jump     = 0;
        aluop    = 2'b00;
    end

    // branch (beq/bne/blt/bge/bltu/bgeu - distinguished by funct3 in branch_comp)
    7'b1100011:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 0;
        memread  = 0;
        memwrite = 0;
        branch   = 1;
        jump     = 0;
        aluop    = 2'b01;
    end

    // I-type (addi, ori)
    7'b0010011:
    begin
        alusrc   = 1;
        memtoreg = 0;
        regwrite = 1;
        memread  = 0;
        memwrite = 0;
        branch   = 0;
        jump     = 0;
        aluop    = 2'b00;
    end

    // jal (Jump and Link) - unconditional, writes PC+4 to rd via 'jump'
    7'b1101111:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 1;
        memread  = 0;
        memwrite = 0;
        branch   = 0;   // NOT a conditional branch anymore
        jump     = 1;   // unconditional redirect + link
        aluop    = 2'b00;
    end

    default:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 0;
        memread  = 0;
        memwrite = 0;
        branch   = 0;
        jump     = 0;
        aluop    = 2'b00;
    end

    endcase
end

endmodule
