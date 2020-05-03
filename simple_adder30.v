// 30-bit Carry Ripple Adder
// ADD operation supported
module simple_adder30(A, B, sum);
    input wire [29:0] A;
    input wire [29:0] B;
    output wire [29:0] sum;

    wire [29:0] carry_temp;
    wire [29:0] sum_temp;

    // Generate 30 1-bit full adders
    adder1 FA_0(
        .A      (A[0]),
        .B      (B[0]),
        .cin    (1'b0),
        .sum    (sum_temp[0]),
        .cout   (carry_temp[0])
    );

    generate
        genvar ii;
        for (ii = 1; ii < 30; ii = ii + 1)
        begin : full_adder_gen
            adder1 FA_n(
                .A      (A[ii]),
                .B      (B[ii]),
                .cin    (carry_temp[ii-1]),
                .sum    (sum_temp[ii]),
                .cout   (carry_temp[ii])
            );
        end
    endgenerate

    // Connect temp output variables
    assign sum = sum_temp;

endmodule