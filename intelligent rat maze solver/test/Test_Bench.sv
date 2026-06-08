//=============================================================================
// Test Bench - Maze Solver Testbench
//=============================================================================
// This testbench instantiates the Intelligent Rat module and Maze Memory
// to test the complete maze solving system. Compatible with ModelSim.
//=============================================================================

`timescale 1ns / 1ns

module tb();
    // Test signals
    reg Start, Run, clk, rst;
    wire Fail, Done, D_in, D_out, RD, WR;
    wire [3:0] X, Y;      // Current position
    wire [1:0] Move;      // Current move direction

    // Instantiate Intelligent Rat (top module)
    intelligent_rat rat(
        .clk(clk), .rst(rst), .Run(Run), .Start(Start),
        .Fail(Fail), .Done(Done), .Move(Move), .X(X), .Y(Y), 
        .D_in(D_in), .D_out(D_out), .RD(RD), .WR(WR)
    );

    // Instantiate Maze Memory
    maze_memory maze(
        .clk(clk), .X(X), .Y(Y), .D_in(D_in), 
        .RD(RD), .WR(WR), .D_out(D_out)
    );

    // Clock generation - 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize all signals
        {Start, Run, clk, rst} = 4'b0;
        
        // Wait and assert Start signal to begin maze solving
        #30 Start = 1'b1;
        #30 Start = 1'b0;
        
        // Wait for maze solving to complete, then assert Run to output path
        #40000 Run = 1'b1;
        #10 Run = 1'b0;
        
        // Wait for path output to complete
        #3000
        
        // Test reset functionality
        #200 rst = 1'b1;
        #200 rst = 1'b0;
        
        // Stop simulation
        #10 $stop;
    end

endmodule
