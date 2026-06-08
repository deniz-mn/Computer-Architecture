# Computer Architecture Assignment 3 (CA3)
## Stack Machine Processor Design

## Problem Statement

Design and implement a simple stack-based processor using SystemVerilog/Verilog. The processor should support basic arithmetic, logical operations, and memory operations using a stack architecture.

## Objectives

1. Design a **Stack Machine** processor with the following components:
   - Control Unit (State Machine)
   - Datapath
   - ALU (Arithmetic Logic Unit)
   - Memory Unit
   - Stack Module

2. Implement the processor in **SystemVerilog/Verilog** and simulate it using **ModelSim**.

3. Support the following instruction set architecture (ISA).

## Instruction Set Architecture (ISA)

### Instruction Format

Each instruction is **8 bits** wide:
- **Bits [7:5]**: Opcode (3 bits)
- **Bits [4:0]**: Operand/Address (5 bits)

### Supported Instructions

| Opcode | Instruction | Description | Example |
|--------|-------------|-------------|---------|
| `000` | **ADD** | Pop two elements from stack, add them, push result | `00000000` |
| `001` | **SUB** | Pop two elements from stack, subtract (top-1 - top), push result | `00100000` |
| `010` | **AND** | Pop two elements from stack, bitwise AND, push result | `01000000` |
| `011` | **NOT** | Pop one element from stack, bitwise NOT, push result | `01100000` |
| `100` | **PUSH** | Push operand value onto stack | `10011001` (PUSH 25) |
| `101` | **POP** | Pop from stack and store in memory at operand address | `10101001` (POP @9) |
| `110` | **JMP** | Unconditional jump to operand address | `11001000` (JMP 8) |
| `111` | **JZ** | Conditional jump if zero flag is set | `11101000` (JZ 8) |

## System Specifications

### Memory
- **Size**: 32 words (8-bit each)
- **Address Range**: 0-31 (5-bit addressing)
- **Usage**: 
  - Addresses 0-31: Instruction memory and data memory
  - Instructions are loaded from `inst.mem` file

### Stack
- **Depth**: 8 levels
- **Width**: 8 bits per element
- **Operations**: Push, Pop
- **Top of Stack (TOS)**: Always accessible

### ALU Operations
- **ADD** (opcode 000): `result = a + b`
- **SUB** (opcode 001): `result = a - b`
- **AND** (opcode 010): `result = a & b`
- **NOT** (opcode 011): `result = ~a`
- **Zero Flag**: Set when result equals zero

### Control Unit (State Machine)

The control unit implements an 8-state finite state machine:

1. **FETCH**: Fetch instruction from memory using PC
2. **READ_MEM**: Read instruction from memory
3. **IDECODE**: Decode instruction and determine next state
4. **POP1**: Pop first operand from stack (for binary operations)
5. **POP2**: Pop second operand from stack (for binary operations)
6. **EXECUTE**: Execute ALU operation
7. **MEM_OP**: Memory operation (PUSH from memory or POP to memory)
8. **WB** (Write Back): Write result back to stack

**State Transition Flow:**
```
FETCH → READ_MEM → IDECODE → [POP1 → POP2 → EXECUTE] / [MEM_OP] → WB → FETCH
```

### Datapath Components

- **Program Counter (PC)**: 8-bit counter
- **Instruction Register (IR)**: 8-bit register
- **Temporary Registers**: temp1, temp2 (for ALU operands)
- **Stack Output Register**: Registered output from stack
- **Memory Output Register**: Registered output from memory

## Implementation Requirements

### Module Structure

1. **TopModule.v**: Top-level module connecting all components
2. **ControlUnit (controller.sv)**: State machine controller
3. **Datapath.v**: Data path implementation
4. **ALU.v**: Arithmetic Logic Unit
5. **Memory.v**: Memory module with read/write capability
6. **Stack.v**: Stack data structure implementation

### Control Signals

The control unit generates the following signals:
- `mem_write`: Memory write enable
- `stack_push`: Stack push enable
- `stack_pop`: Stack pop enable
- `alu_op`: ALU operation select (3 bits)
- `temp1_en`, `temp2_en`: Temporary register enables
- `pc_src`: PC source select (0 = PC+1, 1 = Jump address)
- `pc_write`: PC write enable
- `ir_write`: Instruction register write enable
- `Address_sel`: Address source select (0 = PC, 1 = IR[4:0])
- `stack_input_sel`: Stack input source (0 = ALU result, 1 = Memory output)

## Test Program

A sample test program should be provided in `inst.mem`:

```
PUSH 25    (10011001)
PUSH 26    (10011010)
PUSH 27    (10011011)
PUSH 28    (10011100)
ADD        (00000000)
ADD        (00000000)
ADD        (00000000)
POP 9      (10101001)
JUMP 8     (11001000)
```

## Deliverables

1. **Source Code**: All SystemVerilog/Verilog modules
2. **Testbench**: Complete testbench for simulation
3. **Test Files**: 
   - `inst.mem`: Binary instruction file
   - `assembly.s`: Assembly source code
4. **Documentation**:
   - Design report (Datapath and Controller design)
   - README with usage instructions
5. **Simulation Results**: ModelSim simulation waveforms

## Evaluation Criteria

- Correct implementation of all instructions
- Proper state machine operation
- Correct stack operations (push/pop)
- Memory read/write functionality
- ALU operations correctness
- Code organization and documentation
- Simulation results

## Notes

- Use **blocking assignments** (`=`) in combinational always blocks
- Use **non-blocking assignments** (`<=`) in sequential always blocks
- Ensure proper reset behavior for all registers
- Memory should be initialized from `inst.mem` file using `$readmemb`
- Stack pointer should be properly managed (increment on push, decrement on pop)

## Tools

- **HDL**: SystemVerilog/Verilog
- **Simulator**: ModelSim (or QuestaSim)
- **Synthesis**: Optional (Quartus, Vivado, etc.)

---

**Course**: Computer Architecture  
**Assignment**: CA3 - Stack Machine Processor  
**Language**: SystemVerilog/Verilog  
**Simulator**: ModelSim

