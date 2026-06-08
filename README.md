# Computer Architecture Course Projects

This repository contains my Computer Architecture course projects implemented mainly in SystemVerilog/Verilog and simulated using ModelSim.

## Projects Overview

### CA1 — Intelligent Rat Maze Solver
Implemented a hardware maze solver for a 16×16 maze using the DFS algorithm. The design includes a controller FSM, datapath, stack for backtracking, queue for final path storage, and Python scripts for maze visualization and output conversion. :contentReference[oaicite:0]{index=0}

### CA3 — Multicycle Stack Machine Processor
Designed a multicycle stack-based processor with an FSM controller. The processor supports arithmetic, logical, memory, and jump instructions using an 8-bit datapath, 32-word memory, and 8-level stack. :contentReference[oaicite:1]{index=1}

### CA4 — RISC-V Pipeline Processor
Built a 5-stage pipelined RISC-V processor supporting common load/store, arithmetic, logical, branch, jump, and immediate instructions. The project includes hazard detection, forwarding, stalling, and pipeline flushing. :contentReference[oaicite:2]{index=2}

## Tools & Technologies

- SystemVerilog / Verilog
- ModelSim / QuestaSim
- Python
- Digital design concepts
- FSM-based controller design
- Datapath design
- Stack and queue hardware structures
- Pipeline architecture
- Hazard detection and forwarding

## Summary

Across these projects, I designed and simulated different computer architecture systems, starting from an algorithmic hardware maze solver, then a multicycle stack machine processor, and finally a pipelined RISC-V processor.