// 32-bit ALU
// ALU control signals
// add/u    0/1 000
// sub/u    0/1 001
// and          010
// slt/gt   0/1 011
// xor          100
// seq/ne   0/1 101
// or           110
// sle/ge   0/1 111

module alu32(A, B, ctr, result, zero_out);
    input wire  [31:0]  A;
    input wire  [31:0]  B;
    input wire  [3:0]   ctr;
    output reg  [31:0]  result;
    output wire         zero_out;

    wire [31:0] adder_result;
    wire [31:0] seq_sne;
    wire [31:0] slt_sgt;
    wire [31:0] sle_sge;
    wire [31:0] and_op;
    wire [31:0] or_op;
    wire [31:0] xor_op;
    wire        zero;
    wire        slt_temp;

    // Adder Block
    adder32 adder_unit(
        .A  (A),
        .B  (B),
        .sub(ctr[0]),
        .sum(adder_result),  
        .cout(),
        .zero(zero)   
    );

    assign zero_out = zero;

    // SEQ/SNE Block
    assign seq_sne[31:1] = 31'd0;

    xor_gate_n xor1(
        .a  (zero),
        .b  (ctr[3]),
        .z  (seq_sne[0])
    );

    // SLT/SLGT Block
    assign slt_sgt[31:1] = 31'd0;

    xor_gate_n xor2(
        .a  (ctr[3]),
        .b  (adder_result[31]),
        .z  (slt_temp)
    );
    and_gate_n and1(
        .a  (slt_temp),
        .b  (~zero),
        .z  (slt_sgt[0]) 
    );

    // SLE/SGE Block
    assign sle_sge[31:1] = 31'd0;

    or_gate_n or1(
        .a  (slt_sgt[0]),
        .b  (zero),
        .z  (sle_sge[0])
    );

    // AND Block
    and_gate_n and_unit[0:31](
        .a  (A),
        .b  (B),
        .z  (and_op)
    );

    // OR Block
    or_gate_n or_unit[0:31](
        .a  (A),
        .b  (B),
        .z  (or_op)
    );

    // XOR Block
    xor_gate_n xor_unit[0:31](
        .a  (A),
        .b  (B),
        .z  (xor_op)
    );

    // ALU Mux
    always @(*) begin
      case (ctr[2:0])
        3'b000 : result = adder_result;
        3'b001 : result = adder_result;
        3'b010 : result = and_op;
        3'b011 : result = slt_sgt;
        3'b100 : result = xor_op;
        3'b101 : result = seq_sne;
        3'b110 : result = or_op;
        3'b111 : result = sle_sge;
      endcase
    end
endmodule