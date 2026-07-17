`timescale 1ns / 1ps

module sign_extend(

    input  wire [15:0] immediate,
    input  wire        sign_ext,

    output wire [31:0] extended

);

assign extended = sign_ext ?
                {{16{immediate[15]}}, immediate} :
                {16'b0, immediate};

endmodule