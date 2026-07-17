`timescale 1ns / 1ps
`include "defines.v"

module pc (
    input  wire                     clk,
    input  wire                     reset,

    // Control
    input  wire                     pc_write,   // 1 = update PC, 0 = stall

    // Next PC from branch/jump logic
    input  wire [`DATA_WIDTH-1:0]   next_pc,

    // Current PC
    output reg  [`DATA_WIDTH-1:0]   pc
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        pc <= 32'h00000000;
    else if (pc_write)
        pc <= next_pc;
    // else: retain current PC (stall) - FIXED: This handles stalls properly
end

endmodule