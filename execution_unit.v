// Execution Unit
// ALU32        00
// Shift32      01
// Unsigned MUL 10
// Signed MUL   11

module execution_unit(A, B, alu32_ctr, shift32_ctr, ex_op, result, zero);
    input wire  [31:0]  A;
    input wire  [31:0]  B;
    input wire  [3:0]   alu32_ctr;
    input wire  [1:0]   shift32_ctr;
    input wire  [1:0]   ex_op;
    output reg  [31:0]  result;
    output wire         zero;

    wire [31:0] shift_result;
    wire [31:0] alu_result;

    // Shift Unit
    shift32 shift_unit(
        .A      (A),
        .B      (B),
        .ctr    (shift32_ctr),
        .result (shift_result)
    );

    // ALU
    alu32 alu_block(
        .A          (A),
        .B          (B),
        .ctr        (alu32_ctr),
        .result     (alu_result),
        .zero_out   (zero)
    );

    // Execution Operation Mux
    always@(*) begin
      case (ex_op)
        2'b00 : result = alu_result;
        2'b01 : result = shift_result;
        2'b10 : result = 32'd0;
        2'b11 : result = 32'd0;
      endcase
    end


endmodule