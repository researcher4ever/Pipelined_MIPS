`timescale 1ns / 1ps

module branch_adder(

    input  wire [31:0] pc_plus4,
    input  wire [31:0] immediate,

    output wire [31:0] branch_address

);

assign branch_address = pc_plus4 + (immediate << 2);

endmodule