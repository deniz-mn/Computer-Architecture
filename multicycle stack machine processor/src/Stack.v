module Stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output [7:0] tos
);
    reg [7:0] stack_mem [0:7];
    reg [3:0] sp;

    


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            data_out <= 0;
        end
        else if(pop) begin 
            data_out <= stack_mem[sp - 1] ;
            sp <= sp - 1 ;
        end
        else if(push) begin 
            stack_mem[sp] <= data_in;
            sp <= sp + 1 ;
        end
    end
    
    assign tos = (sp > 0) ? stack_mem[sp - 1] : 8'b0;
endmodule