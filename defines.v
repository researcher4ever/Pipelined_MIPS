`ifndef DEFINES_V
`define DEFINES_V

//--------------------------------------------------
// Data Width
//--------------------------------------------------
`define DATA_WIDTH 32
`define ADDR_WIDTH 32
`define REG_ADDR_WIDTH 5

//--------------------------------------------------
// Opcodes
//--------------------------------------------------
`define OPC_RTYPE 6'b000000
`define OPC_LW    6'b100011
`define OPC_SW    6'b101011
`define OPC_BEQ   6'b000100
`define OPC_BNE   6'b000101
`define OPC_ADDI  6'b001000
`define OPC_ANDI  6'b001100
`define OPC_ORI   6'b001101
`define OPC_SLTI  6'b001010
`define OPC_J     6'b000010
`define OPC_JAL   6'b000011

//--------------------------------------------------
// Function Codes
//--------------------------------------------------
`define FUNC_ADD 6'b100000
`define FUNC_SUB 6'b100010
`define FUNC_AND 6'b100100
`define FUNC_OR  6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_JR  6'b001000

//--------------------------------------------------
// ALU Operations
//--------------------------------------------------
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR  4'b0011
`define ALU_XOR 4'b0100
`define ALU_NOR 4'b0101
`define ALU_SLT 4'b0110
`define ALU_SLL 4'b0111
`define ALU_SRL 4'b1000

//--------------------------------------------------
// Forwarding Control
//--------------------------------------------------
`define FORWARD_NONE 2'b00
`define FORWARD_MEM  2'b10
`define FORWARD_WB   2'b01

`endif