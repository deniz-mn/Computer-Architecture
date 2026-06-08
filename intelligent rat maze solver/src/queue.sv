//=============================================================================
// Queue - FIFO Data Structure for Final Path Storage
//=============================================================================
// This module stores the final solution path and outputs it to a file.
// Path is stored in reverse order and read back in correct order.
//=============================================================================

`define BITS(x) $rtoi($ceil($clog2(x)))  // Macro to calculate address width

module queue (clk, rst, push, init, en_read, data_in, complete_read, data_out);

    // Parameters
    parameter MAX_LENGTH = 256;  // Maximum path length
    parameter WIDTH = 2;          // Data width (direction encoding: 2 bits)

    // Port declarations
    input clk, rst, push, init, en_read;
    input [WIDTH - 1:0] data_in;
    output complete_read;
    output reg [WIDTH - 1:0] data_out;
    reg complete_read;

    // Internal storage and pointers
    reg [WIDTH - 1:0] list [0: MAX_LENGTH - 1];
    reg [`BITS(MAX_LENGTH) - 1:0] ptr, last_ptr, length, read_count;
    reg read_ing;  // Reading flag
    integer result_file;  // File handle for output
    // Queue operations: push (store path), read (output to file)
    always @(posedge clk or posedge rst)
    begin
        if (rst || init) begin
            // Reset/Initialize: clear all pointers and flags
            ptr <= 1'b0;
            last_ptr <= 1'b0;
            length <= 1'b0;
            read_count <= 1'b0;
            read_ing <= 1'b0;
            complete_read <= 1'b0;
        end

        else if (push && (length < MAX_LENGTH)) begin
            // Push: store direction data at end of queue
            list[length] <= data_in;
            length <= length + 1;
        end

        else if (en_read && !read_ing && (length > 0)) begin
            // Start reading: initialize pointers and open output file
            ptr <= length - 1;
            last_ptr <= length - 1;
            read_count <= length;
            read_ing <= 1'b1;
            complete_read <= 1'b0;
            result_file = $fopen("data/result/result.txt", "wb");  // Open file for binary write
        end

        else if (read_ing) begin
            if (read_count > 0) begin
                // Read: output data to file and decrement pointer
                data_out <= list[ptr];
                $fdisplayb(result_file, list[ptr]);  // Write binary format
                ptr <= ptr - 1;
                read_count <= read_count - 1;
            end
            else begin
                // Reading complete: close file and set flag
                ptr <= last_ptr;
                read_ing <= 1'b0;
                complete_read <= 1'b1;
                $fclose(result_file);
            end
        end
    end
    
endmodule

