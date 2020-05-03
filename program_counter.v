// Program Counter 32-bit

module program_counter(clk, rst, addr_in, addr_out, pc_we);
    input wire          clk;
    input wire          rst;
    input wire          pc_we;
    input wire [0:31]   addr_in;
    output reg [0:31]   addr_out;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            addr_out <= 32'h1000; // Quicksort start addr
            // addr_out <= 32'h0; // Fib, unsignedsum start addr
        end 
        else begin
            if (pc_we) begin
                addr_out <= addr_in;
            end 
            else begin
                addr_out <= addr_out;
            end
        end
    end 

endmodule