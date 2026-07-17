`timescale 1ns / 1ps
`include "defines.v"

module control_unit(

    input  wire [5:0] opcode,

    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp

);

always @(*) begin

    // Default values (NOP)
    RegDst   = 1'b0;
    ALUSrc   = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    Branch   = 1'b0;
    Jump     = 1'b0;
    ALUOp    = 2'b00;

    case(opcode)

        // R-Type
        `OPC_RTYPE:
        begin
            RegDst   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b10;
        end

        // Load Word
        `OPC_LW:
        begin
            ALUSrc   = 1'b1;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            MemRead  = 1'b1;
            ALUOp    = 2'b00;
        end

        // Store Word
        `OPC_SW:
        begin
            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        // BEQ
        `OPC_BEQ:
        begin
            Branch = 1'b1;
            ALUOp  = 2'b01;
        end

        // BNE
        `OPC_BNE:
        begin
            Branch = 1'b1;
            ALUOp  = 2'b01;
        end

        // ADDI
        `OPC_ADDI:
        begin
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        // ANDI
        `OPC_ANDI:
        begin
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b11;
        end

        // ORI
        `OPC_ORI:
        begin
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b11;
        end

        // SLTI
        `OPC_SLTI:
        begin
            ALUSrc   = 1'b1;
            RegWrite = 1'b1;
            ALUOp    = 2'b11;
        end

        // Jump
        `OPC_J:
        begin
            Jump = 1'b1;
        end

        // Jump and Link
        `OPC_JAL:
        begin
            Jump     = 1'b1;
            RegWrite = 1'b1;
        end

        default:
        begin
            // NOP
        end

    endcase

end

endmodule