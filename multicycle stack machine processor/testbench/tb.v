`timescale 1ns / 1ns

module tb_Top_1;

    reg clk;
    reg rst;

    TopModule Top  (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20 rst = 0;
        #1000;
        $stop;
    end

endmodule