`define FETCH     5'd0
`define READ_MEM  5'd1
`define IDECODE   5'd2
`define POP1      5'd3
`define POP2      5'd4
`define MEM_OP    5'd5
`define EXECUTE   5'd6
`define WB        5'd7

module ControlUnit (
    input clk,
    input rst,
    input [2:0] opcode,
    input zero_flag,
    output reg mem_write,
    output reg stack_push,
    output reg Address_sel,
    output reg stack_pop,
    output reg [2:0] alu_op,
    output reg temp1_en,
    output reg temp2_en,
    output reg pc_src,
    output reg pc_write,
    output reg ir_write,
    output reg stack_input_sel // 0 = ALU, 1 = Memory
);
    reg [4:0] pstate , nstate ;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            pstate <= `FETCH;
        end
        else begin
            pstate <= nstate;
        end
    end

    always@(*)begin
        mem_write = 1'b0;
        stack_push = 1'b0;
        stack_pop = 1'b0;
        alu_op = 3'b000 ;
        temp1_en = 1'b0;
        temp2_en = 1'b0;
        pc_src = 1'b0;
        Address_sel = 1'b0;
        pc_write = 1'b0;
        ir_write = 1'b0;
        stack_input_sel = 1'b0;
        nstate = `FETCH;
        
        case(pstate)
            `FETCH: begin
                    pc_write = 1'b1;
                    Address_sel = 1'b0;
                    nstate = `READ_MEM;
                end
            `READ_MEM : begin
                    ir_write = 1'b1;
                    nstate = `IDECODE;
            end

            `IDECODE: begin
                    case (opcode)
                        3'b000, 3'b001, 3'b010: begin
                            stack_pop = 1'b1;
                            nstate = `POP1;
                        end
                        3'b011: begin
                            stack_pop = 1'b1;
                            nstate = `POP2;
                        end
                        3'b100: begin // PUSH
                            Address_sel = 1'b1;
                            nstate = `MEM_OP;
                        end
                        3'b101: begin // POP
                            stack_pop = 1'b1;
                            nstate = `MEM_OP;
                        end
                        3'b110: begin // JMP
                            pc_src = 1'b1;
                            pc_write = 1'b1;
                            nstate = `FETCH;
                        end
                        3'b111: begin // JZ
                            if (zero_flag) begin
                                pc_src = 1'b1;
                                pc_write = 1'b1;
                            end
                            nstate = `FETCH;
                        end
                    endcase
                end
            `POP1: begin
                    temp2_en = 1;
                    stack_pop = 1;
                    nstate = `POP2;
                end 

            `POP2: begin
                    temp1_en = 1;
                    nstate = `EXECUTE;
                end

            `EXECUTE: begin
                    case (opcode)
                        3'b000: alu_op = 3'b000; // ADD
                        3'b001: alu_op = 3'b001; // SUB
                        3'b010: alu_op = 3'b010; // AND
                        3'b011: alu_op = 3'b011; // NOT
                    endcase
                    stack_input_sel = 0;
                    stack_push = 1;
                    nstate = `WB;
                end

            `MEM_OP: begin
                    case (opcode)
                        3'b100: begin
                            stack_input_sel = 1'b1;
                            stack_push = 1;
                            nstate = `WB;
                        end
                        3'b101: begin
                            mem_write = 1;
                            Address_sel = 1'b1;
                            nstate = `WB;
                        end
                    endcase
                end

            `WB: nstate = `FETCH;

        endcase
    end

endmodule
