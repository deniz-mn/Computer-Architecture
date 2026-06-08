//=============================================================================
// Intelligent Rat - Top Module
//=============================================================================
// This module implements a maze solving system using Depth-First Search (DFS)
// algorithm. It connects the Controller (state machine) and Datapath units.
//=============================================================================

module intelligent_rat(clk, rst, Run, Start,
                       Fail, Done, Move, X, Y, 
                       D_in, D_out, RD, WR);

    // Parameters
    parameter DIRECTION_SIZE = 2;  // Direction encoding size (2 bits: 00=up, 01=right, 10=left, 11=down)
    parameter N = 4;                // Coordinate size (4 bits for 0-15 range)

    // Port declarations
    input clk, rst, Run, Start, D_out;
    output D_in, Fail, Done, RD, WR;
    output [DIRECTION_SIZE - 1:0] Move;  // Current move direction
    output [N - 1:0] X, Y;                // Current position coordinates

    // Internal control signals between Controller and Datapath
    wire init_x, init_y, ldx, ldy, 
        init_count, ld_count, en_count, list_push,
        en_read, init_list, init_stack, 
        stack_dir_push, stack_dir_pop, 
        r_update, found, empty_stack, 
        complete_read, Co, invalid;

    // Datapath instantiation - handles all data operations
    datapath dp(
        .clk(clk), .rst(rst), .init_x(init_x), .init_y(init_y), .ldx(ldx), .ldy(ldy),
        .ld_count(ld_count), .init_count(init_count), .en_count(en_count), 
        .en_read(en_read), .init_list(init_list), .init_stack(init_stack), .X(X),                         
        .stack_dir_push(stack_dir_push), .stack_dir_pop(stack_dir_pop),  .Y(Y), 
        .Move(Move), .found(found), .empty_stack(empty_stack), .r_update(r_update),
        .complete_read(complete_read), .list_push(list_push), .Co(Co), .invalid(invalid)
    );

    // Controller instantiation - state machine that controls the maze solving flow
    controller cu(
        .clk(clk), .rst(rst), .start(Start), .Run(Run), .Co(Co), .found(found), .WR(WR),
        .complete_read(complete_read), .D_out(D_out), .init_x(init_x), .init_y(init_y),
        .D_in(D_in), .init_stack(init_stack), .init_count(init_count), .en_count(en_count), 
        .stack_pop(stack_dir_pop), .stack_push(stack_dir_push), .r_update(r_update),
        .en_read(en_read), .init_list(init_list), .Done(Done), .Fail(Fail), .empty_stack(empty_stack),
        .ldc(ld_count), .ldx(ldx), .list_push(list_push), .ldy(ldy), .RD(RD), .invalid(invalid)
    );

endmodule
