// 32-bit Multiplier
// 4 stage Multiplier
// Unsigned Mul 0
// Signed Mul   1

module mul32(clk, rst, A, B, sign, unsigned_result, signed_result);
    input wire clk;
    input wire rst;
    input wire [31:0] A;
    input wire [31:0] B;
    input wire sign;
    output wire [63:0] unsigned_result;
    output wire [63:0] signed_result;

    wire [31:0] A_temp, A_pos;
    wire [31:0] B_temp, B_pos;
    wire negateA, negateB;
    wire [31:0] negateA32_sx, negateB32_sx;
    wire [31:0] negateA32, negateB32;
    wire msbA, msbB;
    wire [63:0] unsigned_result_temp;
    wire negate_result;
    wire [63:0] negate_result64;
    wire [63:0] negate_result64_sx;
    wire [63:0] signed_result_temp;

    // Negate Signal
    assign negateA32 = {{31'd0}, {negateA}};
    assign negateB32 = {{31'd0}, {negateB}};
    assign negateA32_sx = {32{negateA}};
    assign negateB32_sx = {32{negateB}};

    assign negate_result64 = {{63'd0}, {negate_result}};
    assign negate_result64_sx = {64{negate_result}};

    // MSB A and B
    assign msbA = A[31];
    assign msbB = B[31];

    // Positive A
    and_gate_n pos_andA(
        .a(sign),
        .b(msbA),
        .z(negateA)
    );
    xor_gate_n pos_xorA[0:31](
        .a(A),
        .b(negateA32_sx),
        .z(A_temp)
    );
    simple_adder32 pos_adderA(
        .A  (A_temp),
        .B  (negateA32),
        .sum(A_pos)
    );

    // Positive B
    and_gate_n pos_andB(
        .a(sign),
        .b(msbB),
        .z(negateB)
    );
    xor_gate_n pos_xorB[0:31](
        .a(B),
        .b(negateB32_sx),
        .z(B_temp)
    );
    simple_adder32 pos_adderB(
        .A  (B_temp),
        .B  (negateB32),
        .sum(B_pos)
    );

    // Unsigned Multiplier
    unsigned_mul32 umul_block(
        .clk    (clk),
        .rst    (rst),
        .A      (A_pos),
        .B      (B_pos),
        .result (unsigned_result_temp)
    );

    // Result Sign
    xor_gate_n sign_xor( 
        .a(msbA),
        .b(msbB),
        .z(negate_result)
    );
    xor_gate_n sign_xor2[0:63]( 
        .a(unsigned_result_temp),
        .b(negate_result64_sx),
        .z(signed_result_temp)
    );
    simple_adder64 sign_adder(
        .A  (signed_result_temp),
        .B  (negate_result64),
        .sum(signed_result)
    );

    // Assign temp to outputs
    assign unsigned_result = unsigned_result_temp;

endmodule