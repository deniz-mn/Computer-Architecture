//=============================================================================
// Counter 2-bit - Direction Counter
//=============================================================================
// This module implements a 2-bit counter used to enumerate through the
// 4 possible directions (00=up, 01=right, 10=left, 11=down).
// Supports count, load, and initialize operations.
//=============================================================================

module counter2bit(rst, clk, init, ld, en, prl, out, Co);
   
    // Port declarations
    input init, ld, en, rst, clk;
    input [1:0] prl;  // Parallel load input
    output reg [1:0] out;  // Counter output
    output Co;  // Carry out (true when counter reaches 11)

    // Counter operation
    always @(posedge clk or posedge rst) begin
        if (rst || init) 
            // Reset or Initialize: clear counter
            out <= 2'b0;
        else if (ld) 
            // Load: set counter to parallel input value
            out <= prl;
        else if (en) 
            // Enable: increment counter
            out <= out + 1;
    end

    // Carry out: true when all bits are 1 (counter = 11)
    assign Co = &out;

endmodule
