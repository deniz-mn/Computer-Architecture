# Problem Statement - RISC-V Pipeline Processor

## Project Overview

This project involves the design and implementation of a complete RISC-V processor with a 5-stage pipeline architecture using SystemVerilog for simulation in ModelSim.

## Objectives

1. **Design a 5-Stage Pipeline Processor**
   - Implement Fetch, Decode, Execute, Memory, and Writeback stages
   - Ensure proper data flow between pipeline stages

2. **Implement Control Unit**
   - Generate control signals based on instruction opcode, funct3, and funct7
   - Support multiple instruction types (R-type, I-type, S-type, B-type, U-type, J-type)

3. **Implement Datapath**
   - Design complete datapath with all necessary components
   - Include Program Counter, Instruction Memory, Register File, ALU, and Data Memory
   - Implement pipeline registers between stages

4. **Hazard Detection and Resolution**
   - Implement Hazard Detection Unit
   - Forwarding from Memory and Writeback stages to Execute stage
   - Stalling for Load-Use hazards
   - Flushing pipeline for control hazards (branches and jumps)

## Supported Instructions

### Load/Store Instructions
- **LW** (Load Word): Load a word from memory to register
- **SW** (Store Word): Store a word from register to memory

### Arithmetic Instructions
- **ADD**: Add two registers
- **SUB**: Subtract two registers
- **ADDI**: Add immediate value to register

### Logical Instructions
- **AND**: Bitwise AND operation
- **OR**: Bitwise OR operation
- **XOR**: Bitwise XOR operation
- **ANDI**: AND with immediate
- **ORI**: OR with immediate
- **XORI**: XOR with immediate

### Comparison Instructions
- **SLT**: Set Less Than (signed comparison)
- **SLTI**: Set Less Than Immediate

### Branch Instructions
- **BEQ**: Branch if Equal
- **BNE**: Branch if Not Equal
- **BLT**: Branch if Less Than (signed)
- **BGE**: Branch if Greater or Equal (signed)

### Jump Instructions
- **JAL**: Jump and Link
- **JALR**: Jump and Link Register

### Upper Immediate Instructions
- **LUI**: Load Upper Immediate

## Technical Requirements

### Pipeline Stages

1. **Fetch (F)**
   - Read instruction from Instruction Memory
   - Increment Program Counter

2. **Decode (D)**
   - Decode instruction
   - Read source registers from Register File
   - Sign extend immediate values

3. **Execute (E)**
   - Perform ALU operations
   - Calculate branch target addresses
   - Determine branch conditions

4. **Memory (M)**
   - Access Data Memory for load/store operations
   - Pass ALU results to next stage

5. **Writeback (W)**
   - Write results back to Register File
   - Select result source (ALU, Memory, PC+4, or Immediate)

### Hazard Handling

#### Data Hazards
- **Forwarding**: Forward data from Memory and Writeback stages to Execute stage
- **Stalling**: Stall pipeline when Load-Use hazard is detected

#### Control Hazards
- **Flushing**: Flush instructions after branch/jump instructions
- **Branch Prediction**: Use branch taken strategy

## Implementation Details

### Modules

1. **RISCV.sv**: Top-level module connecting all components
2. **controller.sv**: Control unit generating control signals
3. **data_path.sv**: Complete datapath implementation
4. **modules.sv**: Helper modules including:
   - ALU (Arithmetic Logic Unit)
   - Register File (32 registers)
   - Instruction Memory
   - Data Memory
   - Hazard Unit
   - Sign Extension Unit
   - Pipeline Registers

### Testing

- Testbench should verify correct execution of all supported instructions
- Test hazard detection and resolution mechanisms
- Verify pipeline correctness and performance

## Deliverables

1. Complete SystemVerilog source code
2. Testbench for verification
3. Architecture diagrams (Controller, Datapath, Hazard Unit)
4. Documentation (README, Setup Guide)

## Evaluation Criteria

- Correctness of instruction execution
- Proper hazard detection and resolution
- Code quality and organization
- Documentation completeness
- Test coverage

## Notes

- All code should be written in SystemVerilog
- Simulation should be performed using ModelSim
- Follow RISC-V instruction set architecture specifications
- Ensure proper handling of edge cases (e.g., register x0 always reads as zero)

