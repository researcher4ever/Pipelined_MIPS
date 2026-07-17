`timescale 1ns / 1ps

module data_memory #

(
    parameter MEM_DEPTH = 1024
)

(
    input wire clk,

    input wire MemRead,
    input wire MemWrite,

    input wire [31:0] address,
    input wire [31:0] write_data,

    output wire [31:0] read_data

);

reg [31:0] memory [0:MEM_DEPTH-1];

// Initialize memory with zeros
integer i;
initial begin
    for(i = 0; i < MEM_DEPTH; i = i + 1)
        memory[i] = 32'b0;
end

//--------------------------------
// Synchronous Write
//--------------------------------

always @(posedge clk)
begin

    if(MemWrite)
        memory[address[31:2]] <= write_data;  // Word-aligned addressing

end

//--------------------------------
// Asynchronous Read
//--------------------------------

assign read_data =
        (MemRead) ?
        memory[address[31:2]]  // Word-aligned addressing
        :
        32'b0;

endmodule