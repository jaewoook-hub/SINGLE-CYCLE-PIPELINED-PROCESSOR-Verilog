// 32-bit Shift Unit 
// SLL  00
// SRL  01
// SRA  10
// LHI  11

module shift32(A, B, ctr, result);
    input wire  [31:0]  A;
    input wire  [31:0]  B;
    input wire  [1:0]   ctr;
    output reg  [31:0]  result;

    wire [31:0] sll_op;
    wire [31:0] srl_op;
    wire [31:0] sra_op;
    wire [31:0] lhi_op;

    // Shift Operations
    assign sll_op = A << B;
    assign srl_op = A >> B;
    assign sra_op = $signed(A) >>> B;
    assign lhi_op = B << 16;

    // Shift Mux
    always@(*) begin
        case(ctr)
            3'b00 : result = sll_op;
            3'b01 : result = srl_op;
            3'b10 : result = sra_op;
            3'b11 : result = lhi_op;
        endcase
    end
endmodule
