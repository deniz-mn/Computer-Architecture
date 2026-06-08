# Project Structure

## 📁 File Organization

```
CA_CA1_Maze/
│
├── src/                          # SystemVerilog source code
│   ├── Intelligent_Rat.sv       # Top module
│   ├── Controller.sv             # State Machine Controller (19 states)
│   ├── Datapath.sv               # Datapath Unit
│   ├── Maze_memory.sv            # Maze memory (16×16)
│   ├── Stack.sv                  # Stack for backtracking in DFS
│   ├── queue.sv                  # Queue for storing final path
│   ├── Register.sv               # Register for X, Y
│   ├── Counter_2bit.sv           # Counter for direction enumeration
│   ├── Mux2to1.sv                # 2-to-1 Multiplexer
│   └── Add_Sub.sv                # Increment/Decrement Unit
│
├── test/                         # Testbench
│   └── Test_Bench.sv             # Main testbench
│
├── scripts/                      # Python scripts
│   ├── draw_maze.py              # Visualize maze
│   └── read_move.py             # Convert binary path to text
│
├── data/                         # Data files
│   ├── maps/                     # Maze files
│   │   ├── map_0.txt             # Default maze
│   │   ├── unsolvable_mazes/       # Unsolvable mazes (no solution exists)
│   │   │   └── unsolvable_maze_0/, unsolvable_maze_1/, unsolvable_maze_2/  # Test cases that should result in Fail
│   │   └── solvable_mazes/        # Solvable mazes (solution exists)
│   │       └── solvable_maze_0/, solvable_maze_1/, solvable_maze_2/, solvable_maze_3/  # Test cases with valid solutions
│   └── result/                    # Simulation output
│       └── result.txt             # Final path in binary format (generated, only for solvable mazes)
│
├── docs/                         # Documentation
│   ├── diagram/                   # Design diagrams
│   │   ├── Conroller.jpeg        # Controller state machine diagram showing 19 states
│   │   ├── Data path_1.jpeg       # Datapath unit diagram (part 1)
│   │   ├── Data path 2.jpeg       # Datapath unit diagram (part 2)
│   │   └── total.jpeg            # Complete system architecture overview
│   └── report/                    # Project report
│       └── Intelligent_Rat_Report.pdf   # Complete project documentation, design details, and analysis
├── problem_statement/            # Problem statement files
│   ├── Problem_Statement.pdf     # Original assignment and problem description
│   └── PROBLEM_STATEMENT.md      # Problem statement details and requirements
│
├── .gitignore                    # Files ignored by Git
├── README.md                     # Main documentation
├── PROJECT_STRUCTURE.md          # This file
├── requirements.txt              # Python dependencies
├── compile.do                    # ModelSim compile script
└── modelsim_logs/                # ModelSim project files and logs (ignored by Git)
    ├── project_file_*.mpf        # ModelSim project files
    └── compilation_report_*.mti  # Compilation reports from different sessions
```

## 🔗 Module Dependencies

```
Intelligent_Rat (Top Module)
├── Controller (State Machine)
└── Datapath
    ├── Register (X, Y)
    ├── Counter_2bit
    ├── Stack
    ├── queue
    ├── Mux2to1 (×3)
    └── Add_Sub (inc_dec)
```

## 📝 Folder Descriptions

### `src/`
Contains all main SystemVerilog modules of the project. These modules must be compiled in the simulator.

### `test/`
Contains testbench for simulation and system testing.

### `scripts/`
Python scripts for:
- **draw_maze.py**: Visualize maze using matplotlib
- **read_move.py**: Convert binary path to readable directions

### `data/`
- **maps/**: Maze files (16×16 bits)
  - **map_0.txt**: Default maze file
  - **unsolvable_mazes/**: Unsolvable mazes - test cases where no path exists from (0,0) to (15,15). These should result in `Fail = 1`.
  - **solvable_mazes/**: Solvable mazes - test cases with valid solutions. These should result in `Done = 1` and generate a path file.
- **result/**: Simulation output directory
  - **result.txt**: Final path in binary format (generated only when solution is found)

### `docs/`
- **diagram/**: System design diagrams
  - **Conroller.jpeg**: Visual representation of the Controller state machine with all 19 states and transitions
  - **Data path_1.jpeg** and **Data path 2.jpeg**: Detailed diagrams of the Datapath unit showing registers, counters, stack, queue, and arithmetic units
  - **total.jpeg**: High-level architecture diagram showing the complete system (Controller + Datapath + Memory)
- **report/**: Project report
  - **Intelligent_Rat_Report.pdf**: Complete project documentation including design methodology, implementation details, test results, and analysis

### `problem_statement/`
- **Problem_Statement.pdf**: Original assignment and problem description (PDF file)
- **PROBLEM_STATEMENT.md**: Detailed explanation of the problem statement, requirements, and design constraints

## 🚀 Usage

1. **Simulation**: Open files from `src/` and `test/Test_Bench.sv` in simulator
2. **Change maze**: Place maze file in `data/maps/` and update path in `Maze_memory.sv`
3. **Run scripts**: 
   ```bash
   python scripts/draw_maze.py [map_file]
   python scripts/read_move.py [input] [output]
   ```

## 🔧 ModelSim Compilation Order

For proper compilation in ModelSim, compile files in this order:

1. Basic modules (no dependencies):
   - `Mux2to1.sv`
   - `Register.sv`
   - `Add_Sub.sv`
   - `Counter_2bit.sv`

2. Data structures:
   - `Stack.sv`
   - `queue.sv`

3. Memory:
   - `Maze_memory.sv`

4. Complex modules:
   - `Datapath.sv`
   - `Controller.sv`

5. Top module:
   - `Intelligent_Rat.sv`

6. Testbench:
   - `test/Test_Bench.sv`

The `compile.do` script handles this automatically.
