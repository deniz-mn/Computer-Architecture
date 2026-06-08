//=============================================================================
// Stack - LIFO Data Structure for DFS Backtracking
//=============================================================================
// This module implements a stack for storing direction information during
// DFS traversal. Used for backtracking when a dead end is reached.
//=============================================================================

`define BITS(x) $rtoi($ceil($clog2(x)))  // Macro to calculate address width

module stack(clk, rst, init, pop, push, empty, d_in, d_out);

    // Parameters
    parameter WIDTH = 2;   // Data width (direction encoding: 2 bits)
    parameter DEPTH = 256; // Stack depth (maximum 256 entries)

    // Port declarations
    input clk, rst, pop, push, init;
    input [WIDTH - 1:0] d_in;
    output [WIDTH - 1:0] d_out;
    output empty;

    // Internal storage
    reg [WIDTH - 1:0] stack [DEPTH - 1:0];
    reg [`BITS(DEPTH) - 1:0] index, next_index;  // Stack pointer
    reg [WIDTH - 1:0] d_out, next_d_out;

    // Empty flag - true when stack is empty (index is 0)
    wire empty;
    assign empty = !(|index);


    // Stack operations - push, pop, and initialization
    always @(posedge clk or posedge rst) begin

        if(rst || init) begin
            // Reset/Initialize: clear stack and reset pointer
            next_d_out  = {WIDTH{1'b0}};
            next_index = 1'b0;
        end

        else if(push) begin
            // Push: store data and increment pointer
            stack[index] = d_in;
            next_index   = index + 1'b1;
        end

        else if(pop) begin
            // Pop: retrieve data and decrement pointer
            next_d_out  = stack[index - 1'b1];
            next_index = index - 1'b1;
        end
        
        else begin
            // Hold: maintain current state
            next_d_out  = d_out;
            next_index = index;
        end

        // Update outputs on clock edge
        d_out  <= next_d_out;
        index <= next_index;
    end

endmodule
