`timescale 1ns / 1ps
`include "defines.v"

module alu_control(

    input  wire [1:0] ALUOp,
    input  wire [5:0] funct,
    input  wire [5:0] opcode,  // This was already there, good

    output reg [3:0] ALUControl

);

always @(*) begin

    case(ALUOp)

        // LW, SW, ADDI
        2'b00:
            ALUControl = `ALU_ADD;

        // BEQ, BNE
        2'b01:
            ALUControl = `ALU_SUB;

        // R-Type
        2'b10:
        begin
            case(funct)

                `FUNC_ADD : ALUControl = `ALU_ADD;
                `FUNC_SUB : ALUControl = `ALU_SUB;
                `FUNC_AND : ALUControl = `ALU_AND;
                `FUNC_OR  : ALUControl = `ALU_OR;
                `FUNC_XOR : ALUControl = `ALU_XOR;
                `FUNC_NOR : ALUControl = `ALU_NOR;
                `FUNC_SLT : ALUControl = `ALU_SLT;
                `FUNC_SLL : ALUControl = `ALU_SLL;
                `FUNC_SRL : ALUControl = `ALU_SRL;

                default:
                    ALUControl = `ALU_ADD;

            endcase
        end

        // Immediate logical instructions
        2'b11:
        begin
            case(opcode)

                `OPC_ANDI:
                    ALUControl = `ALU_AND;

                `OPC_ORI:
                    ALUControl = `ALU_OR;

                `OPC_SLTI:
                    ALUControl = `ALU_SLT;

                default:
                    ALUControl = `ALU_ADD;

            endcase
        end

        default:
            ALUControl = `ALU_ADD;

    endcase

end

endmodule