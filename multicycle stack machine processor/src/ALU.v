module ALU (
    input [7:0] a,
    input [7:0] b,
    input [2:0] op,
    output reg [7:0] result,
    output zero
);
    assign zero = (result == 0);

    always @(*) begin
        case (op)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = ~a;
            default: result = 8'b0;
        endcase
    end
endmodule
