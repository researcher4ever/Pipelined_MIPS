`timescale 1ns / 1ps

module ex_mem(

    input wire clk,
    input wire reset,

    //=========================
    // Data Inputs
    //=========================
    input wire [31:0] branch_addr_in,
    input wire        zero_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] write_data_in,
    input wire [4:0]  write_reg_in,

    //=========================
    // MEM Controls
    //=========================
    input wire Branch_in,
    input wire MemRead_in,
    input wire MemWrite_in,

    //=========================
    // WB Controls
    //=========================
    input wire RegWrite_in,
    input wire MemtoReg_in,

    //=========================
    // Data Outputs
    //=========================
    output reg [31:0] branch_addr_out,
    output reg        zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [4:0]  write_reg_out,

    //=========================
    // MEM Controls
    //=========================
    output reg Branch_out,
    output reg MemRead_out,
    output reg MemWrite_out,

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
        branch_addr_out <= 32'd0;
        zero_out        <= 1'b0;
        alu_result_out  <= 32'd0;
        write_data_out  <= 32'd0;
        write_reg_out   <= 5'd0;

        Branch_out      <= 1'b0;
        MemRead_out     <= 1'b0;
        MemWrite_out    <= 1'b0;

        RegWrite_out    <= 1'b0;
        MemtoReg_out    <= 1'b0;
    end
    else
    begin
        branch_addr_out <= branch_addr_in;
        zero_out        <= zero_in;
        alu_result_out  <= alu_result_in;
        write_data_out  <= write_data_in;
        write_reg_out   <= write_reg_in;

        Branch_out      <= Branch_in;
        MemRead_out     <= MemRead_in;
        MemWrite_out    <= MemWrite_in;

        RegWrite_out    <= RegWrite_in;
        MemtoReg_out    <= MemtoReg_in;
    end

end

endmodule