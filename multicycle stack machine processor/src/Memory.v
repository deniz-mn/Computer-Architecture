module Memory (
    input clk,
    input write_en,
    input [7:0] addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] mem [0:31];


    initial begin
        $readmemb ("../instructions/instructions_binary.mem", mem);
    end


    always @(posedge clk) begin
        if (write_en)
            mem[addr[4:0]] <= data_in;
    end

    
    assign data_out = mem[addr[4:0]];
       
    
endmodule
