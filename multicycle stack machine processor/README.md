# Multicycle Stack Machine Processor - CA3

A multicycle Stack Machine processor implemented in SystemVerilog/Verilog and simulated in ModelSim for Computer Architecture Assignment 3 (CA3). This processor uses a finite state machine (FSM) to execute instructions over multiple clock cycles.

## 📁 Project Structure

```
CA_CA3/
├── src/                   # Source Code Files
│   ├── ALU.v              # Arithmetic Logic Unit
│   ├── controller.sv      # Control Unit (State Machine)
│   ├── Datapath.v         # Datapath
│   ├── Memory.v           # Instruction and Data Memory
│   ├── Stack.v            # Stack Data Structure
│   └── TopModule.v        # Top-level Module
├── testbench/             # Testbench Files
│   └── tb.v               # Main Testbench
├── instructions/          # Instruction Files
│   ├── instructions_assembly.s    # Assembly Code
│   └── instructions_binary.mem    # Binary Instructions
├── docs/                  # Documentation
│   ├── DP_Controller.pdf  # Design Report
│   └── diagram/          # Architecture Diagrams
│       ├── Controller_StateMachine_Diagram.png
│       └── Datapath_Architecture_Diagram.png
├── problem_statement/     # Problem Statement
│   ├── problem_statement_Persian.pdf  # Persian Problem Statement
│   └── problem_statement_English.md   # English Problem Statement
├── modelsim/             # ModelSim Project Files
│   ├── StackMachine_Processor.mpf  # ModelSim Project File
│   ├── StackMachine_Processor.cr.mti  # ModelSim Configuration
│   └── instructions_binary.mem  # Instruction Memory Copy
└── README.md              # This File
```

## 🎯 Project Features

### Supported Instructions:

| Opcode | Instruction | Description |
|--------|-------------|-------------|
| 000    | ADD   | Add two top elements of Stack |
| 001    | SUB   | Subtract two top elements of Stack |
| 010    | AND   | Bitwise AND of two top elements of Stack |
| 011    | NOT   | Bitwise NOT of top element of Stack |
| 100    | PUSH  | Push value onto Stack |
| 101    | POP   | Pop from Stack and store in Memory |
| 110    | JMP   | Unconditional jump |
| 111    | JZ    | Conditional jump (if Zero Flag = 1) |

### Architecture:

- **Multicycle Processor**: Each instruction executes over multiple clock cycles using a finite state machine
- **Stack Machine**: Uses Stack for computational operations
- **State Machine Controller**: Controller with 8 states (FETCH, READ_MEM, IDECODE, POP1, POP2, EXECUTE, MEM_OP, WB)
- **8-bit Data Path**: 8-bit data path
- **32-word Memory**: 32-word memory (8-bit words)
- **8-level Stack**: Stack with depth of 8

## 🚀 Usage

### Prerequisites:

- ModelSim (or QuestaSim)
- SystemVerilog/Verilog Compiler

### Execution Steps:

1. **Open project in ModelSim:**
   ```tcl
   vlib work
   vlog src/*.v src/*.sv
   vlog testbench/tb.v
   vsim work.tb_Top_1
   ```

2. **Or use Project file:**
   - Open `modelsim/StackMachine_Processor.mpf` in ModelSim
   - Make sure `instructions/instructions_binary.mem` is in the correct path

3. **Run simulation:**
   ```tcl
   run 1000ns
   ```

## 📝 Instruction Format

Each instruction is 8 bits:
- **Bits [7:5]**: Opcode (3 bits)
- **Bits [4:0]**: Operand/Address (5 bits)

### Example:
```
10011001 = PUSH 25
  ^^^      ^^^
  PUSH     Operand (25)
```

## 🔧 Configuration

### Changing Program:

To change the program, edit `instructions/instructions_binary.mem`. This file must be in Binary format. You can also edit `instructions/instructions_assembly.s` and convert it to Binary.

Example for creating a new file:
```bash
# Convert Assembly to Binary (requires Assembler)
# Or manually write Binary values
```

### Instruction Files:

The `instructions/` folder contains:
- **instructions_assembly.s**: Assembly source code (human-readable format)
- **instructions_binary.mem**: Binary instruction file (loaded into memory by the processor)

#### Instruction Encoding:

| Assembly | Binary | Opcode | Operand |
|----------|--------|--------|---------|
| PUSH 25  | 10011001 | 100 | 11001 (25) |
| PUSH 26  | 10011010 | 100 | 11010 (26) |
| PUSH 27  | 10011011 | 100 | 11011 (27) |
| PUSH 28  | 10011100 | 100 | 11100 (28) |
| ADD      | 00000000 | 000 | 00000 |
| POP 31   | 10111111 | 101 | 11111 (31) |
| JUMP 8   | 11001000 | 110 | 01000 (8) |

The binary file is automatically loaded by the Memory module during simulation. The memory module expects exactly 32 lines (32 instructions/data words).

## 📊 Multicycle State Machine

This processor implements a **multicycle execution model** where each instruction is executed over multiple clock cycles through a finite state machine:

```
FETCH → READ_MEM → IDECODE → [POP1 → POP2 → EXECUTE] / [MEM_OP] → WB → FETCH
```

### State Descriptions:

- **FETCH**: Fetch instruction from memory using Program Counter (PC)
- **READ_MEM**: Read instruction from memory into Instruction Register (IR)
- **IDECODE**: Decode instruction and determine next state based on opcode
- **POP1/POP2**: Pop operands from stack for binary operations (ADD, SUB, AND)
- **EXECUTE**: Execute ALU operation
- **MEM_OP**: Memory operation (PUSH from memory or POP to memory)
- **WB (Write Back)**: Write result back to stack

Each instruction type requires a different number of cycles:
- **Arithmetic/Logic operations** (ADD, SUB, AND, NOT): 6-7 cycles
- **Memory operations** (PUSH, POP): 4-5 cycles
- **Control operations** (JMP, JZ): 3 cycles

## 🐛 Troubleshooting

### Issue: inst.mem file not found
- Make sure `instructions/instructions_binary.mem` is in the correct path
- Check the path in `src/Memory.v`: `$readmemb ("../instructions/instructions_binary.mem", mem);`

### Issue: Warning in ModelSim
- Make sure all ports are properly connected
- Compile `.v` and `.sv` files correctly

## 📄 License

This project is for educational purposes.
