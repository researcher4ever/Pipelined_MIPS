`timescale 1ns / 1ps

module hazard_detection(

    input wire ID_EX_MemRead,
    input wire [4:0] ID_EX_Rt,

    input wire [4:0] IF_ID_Rs,
    input wire [4:0] IF_ID_Rt,

    output reg PCWrite,
    output reg IF_ID_Write,
    output reg ID_EX_Flush

);

always @(*) begin

    // Default: normal pipeline operation
    PCWrite    = 1'b1;
    IF_ID_Write = 1'b1;
    ID_EX_Flush = 1'b0;

    // Load-use hazard
    if (ID_EX_MemRead &&
    ((ID_EX_Rt == IF_ID_Rs) ||
        (ID_EX_Rt == IF_ID_Rt)))
    begin
        PCWrite     = 1'b0;
        IF_ID_Write = 1'b0;
        ID_EX_Flush = 1'b1;
    end

end

endmodule