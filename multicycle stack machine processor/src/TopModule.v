module TopModule (
    input clk,
    input rst 
);

    wire [2:0] opcode;
    wire [4:0] operand;
    wire zero_flag;

    wire mem_write;
    wire stack_push, stack_pop;
    wire [2:0] alu_op;
    wire temp1_en, temp2_en;
    wire pc_src, pc_write;
    wire ir_write;
    wire stack_input_sel;
    wire Address_sel;

    wire [7:0] tos;

    ControlUnit controler (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .Address_sel(Address_sel),
        .zero_flag(zero_flag),
        .mem_write(mem_write),
        .stack_push(stack_push),
        .stack_pop(stack_pop),
        .alu_op(alu_op),
        .temp1_en(temp1_en),
        .temp2_en(temp2_en),
        .pc_src(pc_src),
        .pc_write(pc_write),
        .ir_write(ir_write),
        .stack_input_sel(stack_input_sel)
    );

    Datapath datapath (
        .clk(clk),
        .rst(rst),
        .mem_write(mem_write),
        .Address_sel(Address_sel),
        .stack_push(stack_push),
        .stack_pop(stack_pop),
        .alu_op(alu_op),
        .temp1_en(temp1_en),
        .temp2_en(temp2_en),
        .pc_src(pc_src),
        .pc_write(pc_write),
        .ir_write(ir_write),
        .stack_input_sel(stack_input_sel),
        .tos(tos),
        .opcode(opcode),
        .operand(operand),
        .zero_flag(zero_flag)
    );

endmodule
