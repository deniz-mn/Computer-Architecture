//=============================================================================
// Increment/Decrement Unit
//=============================================================================
// This module performs increment or decrement operations on coordinates.
// Used to calculate the next position when moving in the maze.
// Detects invalid operations (decrement from 0, increment from max).
//=============================================================================

module inc_dec(a, dec_en, w, invalid);
    parameter N = 4;  // Data width

    // Port declarations
    input [N - 1:0] a;      // Input value
    input dec_en;           // Enable decrement (1=decrement, 0=increment)
    output reg [N - 1:0] w; // Result output
    output reg invalid;     // Invalid operation flag

    // Combinational logic for increment/decrement
    always @(a, dec_en) begin
        // Invalid conditions:
        // - Decrement when input is 0 (would underflow)
        // - Increment when input is max (all 1s, would overflow)
        if(((~|a) && dec_en == 1'b1) || ( &a && dec_en == 1'b0))
            invalid = 1'b1;
        else 
            invalid = 1'b0;
            
        // Perform increment or decrement
        w = (dec_en) ? a - 1 : a + 1;
     end
    
endmodule
