`timescale 1ns / 1ps

module mux5(

    input  wire [4:0] in0,
    input  wire [4:0] in1,

    input  wire sel,

    output wire [4:0] out

);

assign out = sel ? in1 : in0;

endmodule