// Register File
module register_files(
    input           clk,
    input           rst,
    input           RegWr,
    input [0:4]     Rw,
    input [0:31]    Data_in,
    input [0:4]     Rs,
    output[0:31]    BusA,
    input [0:4]     Rt,
    output[0:31]    BusB
    );

    reg [0:31] regfile [0:31];

    assign BusA = regfile[Rs];
    assign BusB = regfile[Rt];  

    integer i;

    always @(posedge clk or negedge rst) begin
        i = 0;
        if (~rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] <= 0;
            end
        end 
        else begin
            if (RegWr) begin
                regfile[Rw] <= Data_in;
            end 
        end
    end 

endmodule