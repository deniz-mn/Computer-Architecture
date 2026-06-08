# Problem Statement

## Assignment File

**`Problem_Statement.pdf`**: The original problem statement and assignment description.

This file contains:
- Project requirements and specifications
- Design constraints and guidelines
- Expected functionality and behavior
- Evaluation criteria
- Implementation guidelines

## Overview

This project implements a hardware solution for solving a 16×16 maze using the Depth-First Search (DFS) algorithm. The system must navigate from the starting position (0,0) to the goal position (15,15) and output the solution path.

## Key Requirements

Based on the problem statement, the system must:

1. **Read maze configuration** from a file (16×16 binary matrix)
2. **Implement DFS algorithm** using hardware components (Stack for backtracking)
3. **Detect solution** when goal is reached (15,15)
4. **Handle failure** when no solution exists
5. **Output path** in binary format (direction encoding)
6. **Use finite state machine** for control flow
7. **Implement datapath** with registers, counters, and arithmetic units

## Design Constraints

- Maze size: 16×16 cells
- Coordinate representation: 4 bits (0-15)
- Direction encoding: 2 bits (00=up, 01=right, 10=left, 11=down)
- Memory: Maze stored in 2D array
- Path storage: Stack for backtracking, Queue for final output

## Expected Behavior

- **Input**: Maze file (binary format, 0=free path, 1=wall)
- **Output**: 
  - `Done = 1` when solution found
  - `Fail = 1` when no solution exists
  - Path file (`result.txt`) with binary direction codes

For detailed specifications, requirements, and evaluation criteria, please refer to the **Problem_Statement.pdf** file.

