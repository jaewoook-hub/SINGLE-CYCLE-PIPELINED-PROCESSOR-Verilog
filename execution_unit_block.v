// Execution Unit Block
// Includes execution unit, immediate extender, branch operant support
// Forwarding muxes included

module execution_unit_block(busA, busB, alu32_ctr, shift32_ctr, execute_ctr, 
                            imm16, BranchEQZ, BranchNEZ, ExtOp, ALUSrc,
                            result, zero, ForwardA, ForwardB, 
                            EXMEM_data, MEMWB_data, busB_Rt);
    input wire  [31:0]  busA;
    input wire  [31:0]  busB;
    input wire  [3:0]   alu32_ctr;
    input wire  [1:0]   shift32_ctr;
    input wire  [1:0]   execute_ctr;
    input wire  [0:15]  imm16;
    input wire          BranchEQZ;
    input wire          BranchNEZ;
    input wire          ExtOp;
    input wire          ALUSrc;
    output wire [31:0]  result;
    output wire         zero;
    output wire [31:0]  busB_Rt;
    input wire [0:1]    ForwardA, ForwardB;
    input wire [0:31]   EXMEM_data, MEMWB_data;

    wire [0:31] imm32;
    wire [0:31] imm32_sext, imm32_zext;
    reg  [0:31] busA_t, busB_t0;
    wire [0:31] busB_t1, busB_t2;
    wire        branch_imm_sel;

    // Immediate Sign and Zero Extend
    sign_ext_16to32 imm16_sext(
        .cin (imm16),
        .cout(imm32_sext)
    );

    zero_ext_16to32 imm16_zext(
        .cin (imm16),
        .cout(imm32_zext)
    );

    // Forwarding Controls
    // busA Forwarding
    always@(*) begin
        case(ForwardA)
            2'b00 : busA_t = busA;
            2'b01 : busA_t = EXMEM_data;
            2'b10 : busA_t = MEMWB_data;
            2'b11 : busA_t = 32'd0;
        endcase
    end

    // busB Forwarding
    always@(*) begin
        case(ForwardB)
            2'b00 : busB_t0 = busB;
            2'b01 : busB_t0 = EXMEM_data;
            2'b10 : busB_t0 = MEMWB_data;
            2'b11 : busB_t0 = 32'd0;
        endcase
    end

    assign busB_Rt = busB_t0;

    // BusB Multiplexing and Brach Operand Support
    assign imm32 = (ExtOp) ? imm32_sext : imm32_zext;
    assign busB_t1 = (ALUSrc) ? imm32 : busB_t0;

    or_gate_n branch_imm(BranchEQZ, BranchNEZ, branch_imm_sel);
    assign busB_t2 = (branch_imm_sel) ? 32'h0 : busB_t1;

    // Execition Unit
    execution_unit exec_block(
        .A          (busA_t),
        .B          (busB_t2),
        .alu32_ctr  (alu32_ctr),
        .shift32_ctr(shift32_ctr),
        .ex_op      (execute_ctr),
        .result     (result),
        .zero       (zero)
    );

endmodule