//=============================================================================
// Maze Memory - 16x16 Maze Storage
//=============================================================================
// This module stores the maze map in a 2D array and provides read/write
// access to individual cells. 0 = free path, 1 = wall.
//=============================================================================

module maze_memory(clk, X, Y, D_in, RD, WR, D_out);
    parameter N = 4;                              // Coordinate size (4 bits)
    parameter FILENAME = "data/maps/map_0.txt";   // Maze file to load
    localparam WIDTH = 16;                        // Maze width
    localparam HEIGHT = 16;                       // Maze height

    // Port declarations
    input [N - 1:0] X, Y;  // Cell coordinates
    input D_in, RD, WR, clk;
    output reg D_out;      // Cell data output

    // Maze storage - 16x16 array of bits
    reg [0:WIDTH - 1] maze [0:HEIGHT - 1];

    // Load maze from file at initialization
    initial begin
        $readmemb(FILENAME, maze);  // Read binary format maze file
    end

    // Write operation - mark cell as visited (set to 1)
    always @(posedge clk) begin 
        if (WR)
            maze[Y][X] <= D_in;
    end
    
    // Read operation - check if cell is wall or free path
    always @(posedge clk) begin
        if (RD)
            D_out <= maze[Y][X];
    end
endmodule

