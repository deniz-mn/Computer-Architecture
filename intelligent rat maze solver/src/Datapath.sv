//=============================================================================
// Datapath - Data Processing Unit
//=============================================================================
// This module contains all data processing components including registers,
// counters, stack, queue, and arithmetic units for maze navigation.
//=============================================================================

module datapath(clk, rst, init_x, init_y, ldx, ldy, ld_count, Co,
                init_count, en_count, list_push, en_read, init_list,
                init_stack, stack_dir_push, stack_dir_pop, r_update,
                X, Y, Move, found, empty_stack, complete_read, invalid,
                add_res, stackp);

    // Parameters
    parameter DIRECTION_SIZE = 2;  // Direction encoding size
    parameter N = 4;                // Coordinate size (4 bits for 0-15)

    input clk, rst, init_x, init_y, ldx, ldy, ld_count,
          init_count, en_count, list_push, en_read, init_list,
          init_stack, stack_dir_push, stack_dir_pop, r_update;

    output [N - 1:0] X, Y, add_res;
    output [DIRECTION_SIZE - 1:0] Move, stackp;
    output found, empty_stack, complete_read, Co, invalid;
    
    // Internal wires
    wire [N - 1:0] mux1, mux2, mux3;
    wire [DIRECTION_SIZE-1:0] counter;
    wire slc_mux, dec_en, fa_co;
    
    // Control logic for increment/decrement and mux selection
    // dec_en: determines if we increment or decrement based on direction and update mode
    assign dec_en = r_update ^ (~counter[0]);
    // slc_mux: selects between X and Y coordinates based on direction
    assign slc_mux = ^counter;

    // Multiplexers for coordinate selection and calculation
    mux2in mux_1(.a(X), .b(add_res), .slc(slc_mux), .w(mux1));  // X register input
    mux2in mux_2(.a(add_res), .b(Y), .slc(slc_mux), .w(mux2));  // Y register input
    mux2in mux_3(.a(Y), .b(X), .slc(slc_mux), .w(mux3));        // Input to add/sub unit

    // Increment/Decrement unit - calculates next position
    inc_dec inc_dec_instance(.a(mux3), .dec_en(dec_en), .w(add_res), .invalid(invalid));

    // Position registers - store current X and Y coordinates
    register regx(.prl(mux1), .clk(clk), .rst(rst), .ld(ldx), .init(init_x), .W(X));
    register regy(.prl(mux2), .clk(clk), .rst(rst), .ld(ldy), .init(init_y), .W(Y));

    // Direction counter - enumerates through 4 directions (00, 01, 10, 11)
    counter2bit counter2b(
        .init(init_count), .ld(ld_count), .en(en_count), .rst(rst),
        .clk(clk), .prl(stackp), .out(counter), .Co(Co)
    );

    // Stack for DFS backtracking - stores path taken
    stack direction_stack(
        .clk(clk), .rst(rst), .pop(stack_dir_pop), .push(stack_dir_push),
        .init(init_stack), .empty(empty_stack), .d_in(counter), .d_out(stackp)
    );

    // Queue for storing final path - outputs moves in correct order
    queue result_list(
        .clk(clk), .rst(rst), .push(list_push), .init(init_list), .en_read(en_read), 
        .data_in(stackp), .complete_read(complete_read), .data_out(Move)
    );

    // Goal detection - checks if both X and Y are at maximum (15,15)
    assign found = &{X, Y};

endmodule
