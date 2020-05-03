// DFF n-bits
module dff_n(clk, rst, we, din, dout);
    parameter n = 1;
    input wire          clk;
    input wire          rst;
    input wire          we;
    input wire [0:n-1]  din;
    output reg [0:n-1]  dout;
	 
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            dout <= 0;
        end 
        else begin
            if (we) begin
                dout <= din;
            end
            else begin
                dout <= dout;
            end 
        end
    end 
    
endmodule