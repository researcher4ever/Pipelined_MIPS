`timescale 1ns / 1ps
`include "defines.v"

module instruction_memory #

(
    parameter MEM_DEPTH = 1024
)

(
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    // Instruction Memory
    reg [31:0] memory [0:MEM_DEPTH-1];

    // Initialize memory
    initial
    begin
        $readmemh("program.mem", memory);
    end

    // Word-aligned instruction fetch
    assign instruction = memory[address[31:2]];

endmodule