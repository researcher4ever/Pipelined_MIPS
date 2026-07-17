`timescale 1ns / 1ps

module mem_wb(

    input wire clk,
    input wire reset,

    //=========================
    // Data Inputs
    //=========================
    input wire [31:0] read_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0]  write_reg_in,

    //=========================
    // WB Controls
    //=========================
    input wire RegWrite_in,
    input wire MemtoReg_in,

    //=========================
    // Data Outputs
    //=========================
    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  write_reg_out,

    //=========================
    // WB Controls
    //=========================
    output reg RegWrite_out,
    output reg MemtoReg_out

);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        read_data_out <= 32'd0;
        alu_result_out <= 32'd0;
        write_reg_out <= 5'd0;

        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;
    end
    else
    begin
        read_data_out <= read_data_in;
        alu_result_out <= alu_result_in;
        write_reg_out <= write_reg_in;

        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;
    end

end

endmodule