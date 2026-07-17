# MIPS32 5-Stage Pipelined Processor

A **32-bit MIPS32 5-stage pipelined processor** implemented in **Behavioral Verilog**. This project demonstrates the implementation of a classic pipelined processor with **hazard detection**, **data forwarding**, **branch handling**, and a modular RTL design suitable for learning computer architecture and FPGA-based digital design.

---

## Features

- 32-bit MIPS32 Processor
- 5-Stage Pipeline
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
- Data Forwarding Unit
- Load-Use Hazard Detection
- Branch and Jump Support
- Modular Behavioral Verilog Design
- FPGA Synthesizable
- Easily Extendable Architecture

---

## Supported Instructions

### R-Type

- ADD
- SUB
- AND
- OR
- XOR
- NOR
- SLT
- SLL
- SRL

### I-Type

- ADDI
- ANDI
- ORI
- SLTI
- LW
- SW
- BEQ
- BNE

### J-Type

- J
- JAL

---

# Processor Architecture

```
                +---------+
                |   PC    |
                +---------+
                     │
                     ▼
        +-------------------------+
        | Instruction Memory (IF) |
        +-------------------------+
                     │
                  IF/ID
                     │
                     ▼
        +-------------------------+
        | Register File + Control |
        |        Unit (ID)        |
        +-------------------------+
                     │
                  ID/EX
                     │
                     ▼
        +-------------------------+
        | ALU + Forwarding (EX)   |
        +-------------------------+
                     │
                 EX/MEM
                     │
                     ▼
        +-------------------------+
        |     Data Memory (MEM)   |
        +-------------------------+
                     │
                 MEM/WB
                     │
                     ▼
        +-------------------------+
        |      Write Back (WB)    |
        +-------------------------+
```

---

## Hazard Handling

### Data Hazards

Resolved using a **Forwarding Unit** that forwards operands from:

- EX/MEM pipeline register
- MEM/WB pipeline register

### Load-Use Hazards

Handled using a **Hazard Detection Unit** that:

- Stalls the Program Counter
- Freezes the IF/ID pipeline register
- Inserts a NOP into the pipeline

### Control Hazards

Supports:

- BEQ
- BNE
- J
- JAL

using branch target calculation and pipeline control.

---

# Project Structure

```
mips32-pipelined-processor/

├── alu.v
├── alu_control.v
├── branch_adder.v
├── control_unit.v
├── data_memory.v
├── defines.v
├── ex_mem.v
├── forwarding_unit.v
├── hazard_detection.v
├── id_ex.v
├── if_id.v
├── instruction_memory.v
├── mem_wb.v
├── mips32_processor.v
├── mux2_32.v
├── mux3_32.v
├── mux5.v
├── pc.v
├── register_file.v
├── sign_extend.v
├── testbench.v
└── README.md
```

---

# Sample Program

```assembly
ADDI $1,$0,10
ADDI $2,$0,20
ADD  $3,$1,$2
SW   $3,0($0)
LW   $4,0($0)
BEQ  $4,$3,label
```

Expected Results

| Register | Value |
| -------- | ----: |
| R1       |    10 |
| R2       |    20 |
| R3       |    30 |
| R4       |    30 |

---

# Design Highlights

- Classic 5-stage pipelined MIPS architecture
- Modular RTL implementation
- Forwarding logic for ALU data hazards
- Hazard Detection Unit for load-use hazards
- Branch and jump control logic
- Parameterized design using `defines.v`
- Behavioral Verilog implementation
- Suitable for FPGA synthesis and academic projects

---

# Specifications

| Parameter       | Value              |
| --------------- | ------------------ |
| Architecture    | MIPS32             |
| Pipeline Stages | 5                  |
| Data Width      | 32-bit             |
| Register File   | 32 × 32-bit        |
| RTL Style       | Behavioral Verilog |
| Memory          | Word Addressable   |

---

# Future Enhancements

- Branch Prediction
- Instruction & Data Cache
- Multiply/Divide Unit
- Exception & Interrupt Handling
- UART Debug Interface
- AXI Bus Interface
- RISC-V ISA Extension

---

# Learning Outcomes

This project demonstrates practical implementation of:

- Computer Architecture
- Processor Datapath Design
- Pipeline Design
- RTL Design using Verilog
- Hazard Detection and Forwarding
- Digital System Design
- FPGA-Oriented Processor Design

---

# Tools Used

- Verilog HDL
- VS Code
- EDA Playground
