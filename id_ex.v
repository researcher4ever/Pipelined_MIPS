`timescale 1ns / 1ps

module id_ex(

    input wire clk,
    input wire reset,
    input wire flush,

    //=========================
    // Data Inputs
    //=========================
    input wire [31:0] pc_plus4_in,
    input wire [31:0] read_data1_in,
    input wire [31:0] read_data2_in,
    input wire [31:0] immediate_in,

    input wire [4:0] rs_in,
    input wire [4:0] rt_in,
    input wire [4:0] rd_in,
    input wire [4:0] shamt_in,

    //=========================
    // EX Controls
    //=========================
    input wire RegDst_in,
    input wire ALUSrc_in,
    input wire [1:0] ALUOp_in,
    input wire SignExt_in,  // ADDED THIS

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
    output reg [31:0] pc_plus4_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rs_out,
    output reg [4:0] rt_out,
    output reg [4:0] rd_out,
    output reg [4:0] shamt_out,

    //=========================
    // EX Controls
    //=========================
    output reg RegDst_out,
    output reg ALUSrc_out,
    output reg [1:0] ALUOp_out,
    output reg SignExt_out,  // ADDED THIS

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

    if(reset || flush)
    begin

        pc_plus4_out <= 32'd0;
        read_data1_out <= 32'd0;
        read_data2_out <= 32'd0;
        immediate_out <= 32'd0;

        rs_out <= 5'd0;
        rt_out <= 5'd0;
        rd_out <= 5'd0;
        shamt_out <= 5'd0;

        RegDst_out <= 1'b0;
        ALUSrc_out <= 1'b0;
        ALUOp_out <= 2'b00;
        SignExt_out <= 1'b0;  // ADDED THIS

        Branch_out <= 1'b0;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;

        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;

    end
    else
    begin

        pc_plus4_out <= pc_plus4_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out <= immediate_in;

        rs_out <= rs_in;
        rt_out <= rt_in;
        rd_out <= rd_in;
        shamt_out <= shamt_in;

        RegDst_out <= RegDst_in;
        ALUSrc_out <= ALUSrc_in;
        ALUOp_out <= ALUOp_in;
        SignExt_out <= SignExt_in;  // ADDED THIS

        Branch_out <= Branch_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;

        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;

    end

end

endmodule