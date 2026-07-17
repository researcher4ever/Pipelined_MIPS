`timescale 1ns / 1ps
`include "defines.v"

module mips_pipelined_top (
    input wire clk,
    input wire reset
);

//===========================================================
// IF/ID Pipeline Registers
//===========================================================
wire [31:0] pc_plus4_if, instruction_if;
wire [31:0] pc_plus4_id, instruction_id;

//===========================================================
// ID/EX Pipeline Registers
//===========================================================
wire [31:0] pc_plus4_ex, read_data1_ex, read_data2_ex, immediate_ex;
wire [4:0] rs_ex, rt_ex, rd_ex, shamt_ex;
wire RegDst_ex, ALUSrc_ex, SignExt_ex;
wire [1:0] ALUOp_ex;
wire Branch_ex, MemRead_ex, MemWrite_ex;
wire RegWrite_ex, MemtoReg_ex;

//===========================================================
// EX/MEM Pipeline Registers
//===========================================================
wire [31:0] branch_addr_mem, alu_result_mem, write_data_mem;
wire [4:0] write_reg_mem;
wire zero_mem;
wire Branch_mem, MemRead_mem, MemWrite_mem;
wire RegWrite_mem, MemtoReg_mem;

//===========================================================
// MEM/WB Pipeline Registers
//===========================================================
wire [31:0] read_data_wb, alu_result_wb;
wire [4:0] write_reg_wb;
wire RegWrite_wb, MemtoReg_wb;

//===========================================================
// Control Signals
//===========================================================
wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
wire [1:0] ALUOp;
wire RegDst_id, ALUSrc_id, MemtoReg_id, RegWrite_id, MemRead_id, MemWrite_id, Branch_id;
wire [1:0] ALUOp_id;

//===========================================================
// Hazard and Forwarding Signals
//===========================================================
wire PCWrite, IF_ID_Write, ID_EX_Flush;
wire [1:0] ForwardA, ForwardB;
wire [31:0] forward_A, forward_B;
wire [4:0] write_reg_ex;

//===========================================================
// Instruction Fetch Stage
//===========================================================
wire [31:0] pc, pc_plus4, pc_next, pc_branch, pc_jump;
wire [31:0] instruction;
wire PCSrc;

// PC
pc pc_inst (
    .clk(clk),
    .reset(reset),
    .pc_write(PCWrite),
    .next_pc(pc_next),
    .pc(pc)
);

// PC + 4 adder
assign pc_plus4 = pc + 32'd4;

// Instruction Memory
instruction_memory #(.MEM_DEPTH(1024)) instruction_memory_inst (
    .address(pc),
    .instruction(instruction)
);

// IF/ID Pipeline Register
if_id if_id_inst (
    .clk(clk),
    .reset(reset),
    .stall(~IF_ID_Write),
    .flush(ID_EX_Flush),
    .instruction_in(instruction),
    .pc_plus4_in(pc_plus4),
    .instruction_out(instruction_id),
    .pc_plus4_out(pc_plus4_id)
);

//===========================================================
// Instruction Decode Stage
//===========================================================
wire [5:0] opcode, funct;
wire [4:0] rs, rt, rd, shamt;
wire [15:0] immediate_16;
wire [25:0] jump_addr;

// Extract instruction fields
assign opcode = instruction_id[31:26];
assign rs = instruction_id[25:21];
assign rt = instruction_id[20:16];
assign rd = instruction_id[15:11];
assign shamt = instruction_id[10:6];
assign funct = instruction_id[5:0];
assign immediate_16 = instruction_id[15:0];
assign jump_addr = instruction_id[25:0];

// Register File
wire [31:0] read_data1, read_data2;
register_file register_file_inst (
    .clk(clk),
    .reset(reset),
    .reg_write(RegWrite_wb),
    .read_reg1(rs),
    .read_reg2(rt),
    .write_reg(write_reg_wb),
    .write_data(MemtoReg_wb ? read_data_wb : alu_result_wb),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Sign Extension
wire [31:0] immediate;
sign_extend sign_extend_inst (
    .immediate(immediate_16),
    .sign_ext(1'b1),  // All our instructions use signed extension
    .extended(immediate)
);

// Control Unit
control_unit control_unit_inst (
    .opcode(opcode),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jump(Jump),
    .ALUOp(ALUOp)
);

// ID/EX Pipeline Register
id_ex id_ex_inst (
    .clk(clk),
    .reset(reset),
    .flush(ID_EX_Flush),
    .pc_plus4_in(pc_plus4_id),
    .read_data1_in(read_data1),
    .read_data2_in(read_data2),
    .immediate_in(immediate),
    .rs_in(rs),
    .rt_in(rt),
    .rd_in(rd),
    .shamt_in(shamt),
    .RegDst_in(RegDst),
    .ALUSrc_in(ALUSrc),
    .ALUOp_in(ALUOp),
    .SignExt_in(1'b1),  // All instructions use sign extension
    .Branch_in(Branch),
    .MemRead_in(MemRead),
    .MemWrite_in(MemWrite),
    .RegWrite_in(RegWrite),
    .MemtoReg_in(MemtoReg),
    .pc_plus4_out(pc_plus4_ex),
    .read_data1_out(read_data1_ex),
    .read_data2_out(read_data2_ex),
    .immediate_out(immediate_ex),
    .rs_out(rs_ex),
    .rt_out(rt_ex),
    .rd_out(rd_ex),
    .shamt_out(shamt_ex),
    .RegDst_out(RegDst_ex),
    .ALUSrc_out(ALUSrc_ex),
    .ALUOp_out(ALUOp_ex),
    .SignExt_out(SignExt_ex),
    .Branch_out(Branch_ex),
    .MemRead_out(MemRead_ex),
    .MemWrite_out(MemWrite_ex),
    .RegWrite_out(RegWrite_ex),
    .MemtoReg_out(MemtoReg_ex)
);

//===========================================================
// Execution Stage
//===========================================================
wire [3:0] ALUControl;
wire [31:0] alu_result;
wire zero, negative, overflow;

// Write register selection
mux5 write_reg_mux (
    .in0(rt_ex),
    .in1(rd_ex),
    .sel(RegDst_ex),
    .out(write_reg_ex)
);

// ALU Control
alu_control alu_control_inst (
    .ALUOp(ALUOp_ex),
    .funct(immediate_ex[5:0]),  // For R-type, funct is in immediate lower bits
    .opcode(immediate_ex[31:26]), // For I-type, opcode is in immediate upper bits
    .ALUControl(ALUControl)
);

// Forwarding MUX for A
mux3_32 forwardA_mux (
    .in0(read_data1_ex),
    .in1(alu_result_mem),
    .in2(alu_result_wb),
    .sel(ForwardA),
    .out(forward_A)
);

// Forwarding MUX for B
mux3_32 forwardB_mux (
    .in0(read_data2_ex),
    .in1(alu_result_mem),
    .in2(alu_result_wb),
    .sel(ForwardB),
    .out(forward_B)
);

// ALU Input MUX (for immediate)
wire [31:0] alu_input_b;
mux2_32 alu_src_mux (
    .in0(forward_B),
    .in1(immediate_ex),
    .sel(ALUSrc_ex),
    .out(alu_input_b)
);

// ALU
alu alu_inst (
    .A(forward_A),
    .B(alu_input_b),
    .ALUControl(ALUControl),
    .shamt(shamt_ex),
    .Result(alu_result),
    .Zero(zero),
    .Negative(negative),
    .Overflow(overflow)
);

// Branch Adder
wire [31:0] branch_addr;
branch_adder branch_adder_inst (
    .pc_plus4(pc_plus4_ex),
    .immediate(immediate_ex),
    .branch_address(branch_addr)
);

// Jump Address
assign pc_jump = {pc_plus4_ex[31:28], jump_addr, 2'b00};

// EX/MEM Pipeline Register
ex_mem ex_mem_inst (
    .clk(clk),
    .reset(reset),
    .branch_addr_in(branch_addr),
    .zero_in(zero),
    .alu_result_in(alu_result),
    .write_data_in(forward_B),  // Use forwarded B value
    .write_reg_in(write_reg_ex),
    .Branch_in(Branch_ex),
    .MemRead_in(MemRead_ex),
    .MemWrite_in(MemWrite_ex),
    .RegWrite_in(RegWrite_ex),
    .MemtoReg_in(MemtoReg_ex),
    .branch_addr_out(branch_addr_mem),
    .zero_out(zero_mem),
    .alu_result_out(alu_result_mem),
    .write_data_out(write_data_mem),
    .write_reg_out(write_reg_mem),
    .Branch_out(Branch_mem),
    .MemRead_out(MemRead_mem),
    .MemWrite_out(MemWrite_mem),
    .RegWrite_out(RegWrite_mem),
    .MemtoReg_out(MemtoReg_mem)
);

//===========================================================
// Memory Stage
//===========================================================
wire [31:0] read_data;

// Data Memory
data_memory #(.MEM_DEPTH(1024)) data_memory_inst (
    .clk(clk),
    .MemRead(MemRead_mem),
    .MemWrite(MemWrite_mem),
    .address(alu_result_mem),
    .write_data(write_data_mem),
    .read_data(read_data)
);

// MEM/WB Pipeline Register
mem_wb mem_wb_inst (
    .clk(clk),
    .reset(reset),
    .read_data_in(read_data),
    .alu_result_in(alu_result_mem),
    .write_reg_in(write_reg_mem),
    .RegWrite_in(RegWrite_mem),
    .MemtoReg_in(MemtoReg_mem),
    .read_data_out(read_data_wb),
    .alu_result_out(alu_result_wb),
    .write_reg_out(write_reg_wb),
    .RegWrite_out(RegWrite_wb),
    .MemtoReg_out(MemtoReg_wb)
);

//===========================================================
// Branch Logic
//===========================================================
wire branch_taken;
assign branch_taken = (Branch_mem && zero_mem); // BEQ only
assign PCSrc = branch_taken || Jump;

// PC MUX
mux2_32 pc_mux (
    .in0(pc_plus4),
    .in1(branch_taken ? branch_addr_mem : pc_jump),
    .sel(PCSrc),
    .out(pc_next)
);

//===========================================================
// Hazard Detection Unit
//===========================================================
hazard_detection hazard_detection_inst (
    .ID_EX_MemRead(MemRead_ex),
    .ID_EX_Rt(rt_ex),
    .IF_ID_Rs(rs),
    .IF_ID_Rt(rt),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .ID_EX_Flush(ID_EX_Flush)
);

//===========================================================
// Forwarding Unit
//===========================================================
forwarding_unit forwarding_unit_inst (
    .EX_MEM_RegWrite(RegWrite_mem),
    .EX_MEM_Rd(write_reg_mem),
    .MEM_WB_RegWrite(RegWrite_wb),
    .MEM_WB_Rd(write_reg_wb),
    .ID_EX_Rs(rs_ex),
    .ID_EX_Rt(rt_ex),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

endmodule