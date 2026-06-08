# ModelSim Compilation Script
# This script compiles all SystemVerilog files in the correct order
# Usage: In ModelSim, type: do compile.do

# Create work library if it doesn't exist
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# Compile basic modules (no dependencies)
vlog -work work src/Mux2to1.sv
vlog -work work src/Register.sv
vlog -work work src/Add_Sub.sv
vlog -work work src/Counter_2bit.sv

# Compile data structures
vlog -work work src/Stack.sv
vlog -work work src/queue.sv

# Compile memory module
vlog -work work src/Maze_memory.sv

# Compile complex modules
vlog -work work src/Datapath.sv
vlog -work work src/Controller.sv

# Compile top module
vlog -work work src/Intelligent_Rat.sv

# Compile testbench
vlog -work work test/Test_Bench.sv

# Display compilation status
echo "Compilation complete!"
echo "To run simulation, type: vsim -voptargs=+acc work.tb"

