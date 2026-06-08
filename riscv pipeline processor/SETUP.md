# Setup Guide

## Prerequisites

- ModelSim or QuestaSim (version 10.5 or higher)
- SystemVerilog support

## Installation and Setup

### Method 1: Using ModelSim Project File

1. Open ModelSim
2. From menu: `File > Open > CA4.mpf`
3. Project will be automatically loaded

### Method 2: Manual Compilation

1. Open ModelSim
2. Navigate to project directory:
   ```tcl
   cd /path/to/CA4
   ```
3. Compile files:
   ```tcl
   vlog src/RISCV.sv src/controller.sv src/data_path.sv src/modules.sv test/riscv_tb.sv
   ```
4. Create work library:
   ```tcl
   vlib work
   vmap work work
   ```
5. Run simulation:
   ```tcl
   vsim -voptargs=+acc riscv_tb
   run -all
   ```

## File Structure

### Main Files (src/)

- **RISCV.sv**: Main processor module that connects all components
- **controller.sv**: Control unit that generates control signals
- **data_path.sv**: Datapath including all Pipeline stages
- **modules.sv**: Helper modules including ALU, Memory, Register File, Hazard Unit, etc.

### Test Files (test/)

- **riscv_tb.sv**: Main testbench for simulation

### Data Files (data/)

- **instructions.txt**: Program instructions in binary format
- **array.txt**: Initial memory data

## Running Tests

After compilation and running simulation, you can:

1. View waveforms:
   ```tcl
   add wave -radix hex /riscv_tb/cpu/*
   ```

2. Check register values:
   - There is a `$display` in `registerFile` code to show values of x6 and x8

3. Adjust simulation time:
   - You can change the `$stop` time in `riscv_tb.sv`

## Troubleshooting

### File Path Error

If you get `Cannot open file` error:
- Make sure you run simulation from the main project directory (CA4)
- Check the paths of `data/` files

### Compilation Error

- Make sure SystemVerilog is enabled in ModelSim
- Compilation order matters: compile `modules.sv` first, then other files

### Simulation Issues

- If simulation doesn't stop, check the `$stop` time in testbench
- Use `$display` for more detailed information

## Important Notes

1. **File Paths**: Data files must be in the `data/` folder
2. **Compilation Order**: `modules.sv` must be compiled before other files
3. **Reset**: Processor starts with `rst = 1` and then `rst = 0`

## Support

If you encounter any issues, please check Issues on GitHub or create a new Issue.
