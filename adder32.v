// 32-bit Carry Ripple Adder
// ADD and SUB operations supported and overflow
module adder32(A, B, sub, sum, cout, zero);
    input wire [31:0] A;
    input wire [31:0] B;
    input wire sub;
    output wire [31:0] sum;
    output wire cout;
    output wire zero;

    wire [31:0] sub32;
    wire [31:0] B_sub;
    wire [31:0] carry_temp;
    wire [31:0] sum_temp;

    // SUB operation support
    assign sub32 = {{31{sub}}, sub};

    xor_gate_n sub_xor[0:31](
        .a(sub32),
        .b(B),
        .z(B_sub)
    );

    // Generate 32 1-bit full adders
    adder1 FA_0(
        .A      (A[0]),
        .B      (B_sub[0]),
        .cin    (sub),
        .sum    (sum_temp[0]),
        .cout   (carry_temp[0])
    );

    generate
        genvar ii;
        for (ii = 1; ii < 32; ii = ii + 1)
        begin : full_adder_gen
            adder1 FA_n(
                .A      (A[ii]),
                .B      (B_sub[ii]),
                .cin    (carry_temp[ii-1]),
                .sum    (sum_temp[ii]),
                .cout   (carry_temp[ii])
            );
        end
    endgenerate

    // Generate zero flag
    nor_gate_32to1 zero_nor(
        .a(sum),
        .z(zero)
    );

    // Connect temp output variables
    assign sum = sum_temp;
    assign cout = carry_temp[31];

endmodule