// 32-bit Unsigned Multiplier
// 4 Stage-Multiplier
// 32x32-bit adders. 8x32-bit adders per stage.

module unsigned_mul32(clk, rst, A, B, result);
    input wire clk;
    input wire rst;
    input wire [31:0] A;
    input wire [31:0] B;
    output wire [63:0] result;

    wire [31:0] ground32;

    // Stage_0 Wires
    wire [31:0] B0_32;
    wire [31:0] andop_00;
    wire [263:0] mul_0x;
    reg  [31:0] mul_0x_n;
    wire [7:0] stage_0;
    reg  [7:0] stage_0_n;

    // Stage_1 Wires
    wire [31:0] B8_32;
    wire [31:0] andop_10;
    wire [263:0] mul_1x;
    reg  [31:0] mul_1x_n;
    wire [7:0] stage_1;
    reg  [15:0] stage_1_n;

    // Stage_2 Wires
    wire [31:0] B16_32;
    wire [31:0] andop_20;
    wire [263:0] mul_2x;
    reg  [31:0] mul_2x_n;
    wire [7:0] stage_2;
    reg  [23:0] stage_2_n;

    // Stage_3 Wires
    wire [31:0] B24_32;
    wire [31:0] andop_30;
    wire [263:0] mul_3x;
    wire [7:0] stage_3;

    // Zero signal
    assign ground32 = 32'd0;

    // Generate Stage_0
    assign B0_32 = {32{B[0]}};

    and_gate_n and00[0:31](
        .a  (A),
        .b  (B0_32),
        .z  (andop_00)
    );

    adder32 FA32_00(
        .A      (ground32),
        .B      (andop_00),
        .sub    (1'b0),
        .sum    (mul_0x[31:0]),
        .cout   (mul_0x[32])
    );

    assign stage_0[0] = mul_0x[0];

    generate
        genvar i0;
        for(i0 = 1; i0 < 8; i0 = i0 + 1)
        begin : stage_0_gen
            wire [31:0] Bx_32;
            wire [31:0] andop_0x;
            assign Bx_32 = {32{B[i0]}};

            and_gate_n and0x[0:31](
                .a  (A),
                .b  (Bx_32),
                .z  (andop_0x)
            );

            adder32 FA32_0x(
                .A  (mul_0x[(33*i0)-1 : 33*(i0-1)+1]),
                .B  (andop_0x),
                .sub(1'b0),
                .sum(mul_0x[33*(i0+1)-2 : 33*(i0)]),
                .cout(mul_0x[33*(i0+1)-1])
            );

            assign stage_0[i0] = mul_0x[33*(i0)];
        end
    endgenerate

    always@(posedge clk)
    begin
        if (rst == 1) begin
            stage_0_n = 0;
            mul_0x_n = 0;
        end
        else begin
            stage_0_n = stage_0;
            mul_0x_n = mul_0x[263:232];
        end
    end

    // Generate Stage_1
    assign B8_32 = {32{B[8]}};

    and_gate_n and10[0:31](
        .a  (A),
        .b  (B8_32),
        .z  (andop_10)
    );

    adder32 FA32_10(
        .A      (mul_0x_n),
        .B      (andop_10),
        .sub    (1'b0),
        .sum    (mul_1x[31:0]),
        .cout   (mul_1x[32])
    );

    assign stage_1[0] = mul_1x[0];

    generate
        genvar i1;
        for(i1 = 1; i1 < 8; i1 = i1 + 1)
        begin : stage_1_gen
            wire [31:0] Bx_32;
            wire [31:0] andop_1x;
            assign Bx_32 = {32{B[i1+8]}};

            and_gate_n and1x[0:31](
                .a  (A),
                .b  (Bx_32),
                .z  (andop_1x)
            );

            adder32 FA32_1x(
                .A  (mul_1x[(33*i1)-1 : 33*(i1-1)+1]),
                .B  (andop_1x),
                .sub(1'b0),
                .sum(mul_1x[33*(i1+1)-2 : 33*(i1)]),
                .cout(mul_1x[33*(i1+1)-1])
            );

            assign stage_1[i1] = mul_1x[33*(i1)];
        end
    endgenerate

    always@(posedge clk)
    begin
        if (rst == 1) begin
            stage_1_n <= 0;
            mul_1x_n <= 0;
        end
        else begin
            stage_1_n <= {stage_1, stage_0_n};
            mul_1x_n <= mul_1x[263:232];
        end
    end

    // Generate Stage_2
    assign B16_32 = {32{B[16]}};

    and_gate_n and20[0:31](
        .a  (A),
        .b  (B16_32),
        .z  (andop_20)
    );

    adder32 FA32_20(
        .A      (mul_1x_n),
        .B      (andop_20),
        .sub    (1'b0),
        .sum    (mul_2x[31:0]),
        .cout   (mul_2x[32])
    );

    assign stage_2[0] = mul_2x[0];

    generate
        genvar i2;
        for(i2 = 1; i2 < 8; i2 = i2 + 1)
        begin : stage_2_gen
            wire [31:0] Bx_32;
            wire [31:0] andop_2x;
            assign Bx_32 = {32{B[i2+16]}};

            and_gate_n and2x[0:31](
                .a  (A),
                .b  (Bx_32),
                .z  (andop_2x)
            );

            adder32 FA32_2x(
                .A  (mul_2x[(33*i2)-1 : 33*(i2-1)+1]),
                .B  (andop_2x),
                .sub(1'b0),
                .sum(mul_2x[33*(i2+1)-2 : 33*(i2)]),
                .cout(mul_2x[33*(i2+1)-1])
            );

            assign stage_2[i2] = mul_2x[33*(i2)];
        end
    endgenerate

    always@(posedge clk)
    begin
        if (rst == 1) begin
            stage_2_n <= 0;
            mul_2x_n <= 0;
        end
        else begin
            stage_2_n <= {stage_2, stage_1_n};
            mul_2x_n <= mul_2x[263:232];
        end
    end

    // Generate Stage_3
    assign B24_32 = {32{B[24]}};

    and_gate_n and30[0:31](
        .a  (A),
        .b  (B24_32),
        .z  (andop_30)
    );

    adder32 FA32_30(
        .A      (mul_2x_n),
        .B      (andop_30),
        .sub    (1'b0),
        .sum    (mul_3x[31:0]),
        .cout   (mul_3x[32])
    );

    assign stage_3[0] = mul_3x[0];

    generate
        genvar i3;
        for(i3 = 1; i3 < 8; i3 = i3 + 1)
        begin : stage_3_gen
            wire [31:0] Bx_32;
            wire [31:0] andop_3x;
            assign Bx_32 = {32{B[i3+24]}};

            and_gate_n and3x[0:31](
                .a  (A),
                .b  (Bx_32),
                .z  (andop_3x)
            );

            adder32 FA32_3x(
                .A  (mul_3x[(33*i3)-1 : 33*(i3-1)+1]),
                .B  (andop_3x),
                .sub(1'b0),
                .sum(mul_3x[33*(i3+1)-2 : 33*(i3)]),
                .cout(mul_3x[33*(i3+1)-1])
            );

            assign stage_3[i3] = mul_3x[33*(i3)];
        end
    endgenerate

    assign result = {mul_3x[263:232], stage_3, stage_2_n};


endmodule