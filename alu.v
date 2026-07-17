`timescale 1ns / 1ps
`include "defines.v"

module alu(

    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,
    input  wire [4:0]  shamt,

    output reg  [31:0] Result,
    output wire Zero,
    output wire Negative,
    output reg  Overflow

);

always @(*) begin

    Overflow = 1'b0;

    case(ALUControl)

        `ALU_ADD:
        begin
            Result = A + B;

            Overflow = (~A[31] & ~B[31] & Result[31]) |
                       ( A[31] &  B[31] & ~Result[31]);
        end

        `ALU_SUB:
        begin
            Result = A - B;

            Overflow = (~A[31] & B[31] & Result[31]) |
                       ( A[31] & ~B[31] & ~Result[31]);
        end

        `ALU_AND:
            Result = A & B;

        `ALU_OR:
            Result = A | B;

        `ALU_XOR:
            Result = A ^ B;

        `ALU_NOR:
            Result = ~(A | B);

        `ALU_SLT:
            Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

        `ALU_SLL:
            Result = B << shamt;

        `ALU_SRL:
            Result = B >> shamt;

        default:
            Result = 32'd0;

    endcase

end

assign Zero     = (Result == 32'd0);
assign Negative = Result[31];

endmodule