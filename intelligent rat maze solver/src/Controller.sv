//=============================================================================
// Controller - State Machine for Maze Solving
//=============================================================================
// This module implements a finite state machine with 19 states that controls
// the entire maze solving process using DFS algorithm.
//=============================================================================

// State definitions
`define S1         5'b00000  // Idle state - waiting for start
`define S2         5'b00001  // Initialize all registers and stacks
`define S3         5'b00010  // Initialize counter
`define S4         5'b00011  // Push direction to stack
`define S5         5'b00100  // Load new position (X, Y)
`define S6         5'b00101  // Write visited mark to maze memory
`define S7         5'b00110  // Check if goal reached, read maze cell
`define S8         5'b00111  // Check if current cell is valid (not wall)
`define S9         5'b01000  // Check if stack is empty (backtrack needed)
`define S10        5'b01001  // Pop direction from stack
`define S11        5'b01010  // Load counter with popped direction
`define S12        5'b01011  // Update position and mark as backtrack
`define S13        5'b01100  // Mark cell as visited, check counter overflow
`define S14        5'b01101  // Increment direction counter
`define S15        5'b01110  // Fail state - no solution found
`define S16        5'b01111  // Goal reached - pop path from stack
`define S17        5'b10000  // Push path to result queue
`define S18        5'b10001  // Done state - waiting for Run signal
`define S19        5'b10010  // Read and output path from queue

module controller(
    input clk, rst, start, Run, Co, found,
    input empty_stack, complete_read, D_out, invalid,

    output reg init_x, init_y, init_count, en_count,
    output reg ldc, ldx, ldy, WR, RD, D_in, Done, 
    output reg list_push, en_read, init_list, Fail,
    output reg init_stack, stack_push, stack_pop,
    output reg r_update
);

    // State registers
    reg [4:0] pstate = `S1;  // Present state
    reg [4:0] nstate = `S1; // Next state

    // Next state logic (combinational)
    always @(*) begin
        case (pstate)
            `S1:                    nstate = ~start ? `S1: `S2;                        
            `S2:                    nstate = ~start ? `S3 : `S2;                        
            `S3:                    nstate = `S6;                        
            `S6:                    nstate = ~invalid ? `S4 : `S13;                        
            `S4:                    nstate = `S5;                       
            `S5:                    nstate = `S7;                        
            `S7:                    nstate = found ? `S16 : `S8;                        
            `S8:                    nstate = D_out ? `S9 : `S3;                        
            `S9:                    nstate = empty_stack ? `S15 : `S10;                        
            `S10:                   nstate = `S11;                         
            `S11:                   nstate = `S12;                        
            `S12:                   nstate = `S13;                       
            `S13:                   nstate = Co ? `S9 : `S14;                        
            `S14:                   nstate = `S6;                        
            `S15:                   nstate = `S15;                        
            `S16:                   nstate = `S17;                        
            `S17:                   nstate = ~empty_stack ? `S16 : `S18;                        
            `S18:                   nstate = Run ? `S19 : `S18;                        
            `S19:                   nstate = complete_read ? `S18 : `S19;            
        endcase
    end
    
    // Output logic (combinational) - generates control signals for each state
    always @(*) begin
        // Default: all control signals are 0
        {init_x, init_y, init_count, init_stack, en_count, ldc, ldx, ldy,
         WR, RD, D_in, stack_pop, list_push, en_read, init_list,
         r_update, stack_push, Done, Fail} = 19'b0;
        
        case (pstate)
            `S2: begin
                init_x = 1'b1;
                init_y = 1'b1;
                init_list = 1'b1;
                init_stack = 1'b1;
                init_count = 1'b1;
            end
            `S3:        init_count = 1'b1;
            `S6:         begin WR = 1'b1; D_in = 1'b1; end
            `S4:      stack_push = 1'b1;
            `S5:         begin ldx = 1'b1; ldy = 1'b1; end
            `S7:        RD = 1'b1;
            `S10:         stack_pop = 1'b1;
            `S11:    ldc = 1'b1;
            `S12:    begin ldx = 1'b1; ldy = 1'b1; r_update = 1'b1; end
            `S13: WR = 1'b1;
            `S14:        en_count = 1'b1;
            `S15:              Fail = 1'b1;
            `S16:        stack_pop = 1'b1;
            `S17:       list_push = 1'b1;
            `S18:              Done = 1'b1;
            `S19:              begin en_read = 1'b1; Done = 1'b1; end
        endcase
    end

    // State register update (sequential)
    always @(posedge clk or posedge rst) begin
        if (rst)
            pstate <= `S1;  // Reset to idle state
        else 
            pstate <= nstate;  // Update to next state
    end

endmodule
