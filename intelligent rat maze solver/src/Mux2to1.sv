//=============================================================================
// Multiplexer 2-to-1 - N-bit 2-input Multiplexer
//=============================================================================
// This module implements a 2-to-1 multiplexer used for coordinate selection
// in the datapath. Selects between two N-bit inputs based on select signal.
//=============================================================================

module mux2in(a, b, slc, w);
    parameter N = 4;  // Data width

    // Port declarations
    input [N - 1:0] a, b;  // Input signals
    input slc;              // Select signal (0 = a, 1 = b)
    output [N - 1:0] w;     // Output signal

    // Multiplexer logic
    assign w = ~slc ? a : b;
endmodule
