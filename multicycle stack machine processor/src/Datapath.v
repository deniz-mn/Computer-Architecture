module Datapath (
    input clk, rst,
    input  mem_write,
    input stack_push, stack_pop,
    input [2:0] alu_op,
    input Address_sel ,
    input temp1_en, temp2_en,
    input pc_src, pc_write,
    input ir_write,
    input stack_input_sel,
    output [7:0] tos,
    output [2:0] opcode,
    output [4:0] operand,
    output zero_flag
);

    reg [7:0] PC;
    reg [7:0] IR;
    reg [7:0] temp1, temp2;
    reg [7:0] stack_out_reg;
    reg [7:0] mem_out_reg;

    wire [7:0] mem_out;
    wire [7:0] alu_result;
    wire [7:0] stack_out;

    wire [7:0] mem_in = stack_out;
    wire [7:0] mem_addr = (Address_sel) ? {3'b000, IR[4:0]} : PC;
    wire [7:0] stack_data_in = (stack_input_sel) ? mem_out_reg : alu_result;

    Memory memory_unit (
        .clk(clk),
        .write_en(mem_write),
        .addr(mem_addr),
        .data_in(mem_in),
        .data_out(mem_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 0;
            IR <= 0;
        end else begin
            if (pc_write)
                PC <= (pc_src) ? {3'b000, IR[4:0]} : PC + 1;
            if (ir_write)
                IR <= mem_out_reg;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp1 <= 0;
            temp2 <= 0;
        end else begin
            if (temp1_en) temp1 <= stack_out;
            if (temp2_en) temp2 <= stack_out;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            stack_out_reg <= 0;
        else
            stack_out_reg <= stack_out;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            mem_out_reg <= 0;
        else
            mem_out_reg <= mem_out;
    end

    Stack stack (
        .clk(clk),
        .rst(rst),
        .push(stack_push),
        .pop(stack_pop),
        .data_in(stack_data_in),
        .data_out(stack_out),
        .tos(tos)
    );

    ALU alu (
        .a(temp2),
        .b(temp1),
        .op(alu_op),
        .result(alu_result),
        .zero(zero_flag)
    );

    assign opcode = IR[7:5];
    assign operand = IR[4:0];
endmodule
