//=============================================================================
// Register - N-bit Register with Load and Initialize
//=============================================================================
// This module implements a general-purpose register used for storing
// X and Y coordinates. Supports load, initialize, and reset operations.
//=============================================================================

module register(prl, clk, rst, ld, init, W);
    parameter N = 4;  // Register width

    // Port declarations
    input [N - 1:0] prl;  // Parallel load input
    input clk, rst, ld, init; 
    output reg [N - 1:0] W;  // Register output

    // Register operation
    always @(posedge clk or posedge rst) begin 
        if (rst || init) 
            // Reset or Initialize: clear register
            W <= {N{1'b0}};
        else if (ld) 
            // Load: store parallel input
            W <= prl;
    end
endmodule
    
