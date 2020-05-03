// Control Logic
// Main control, execution_unit_ctr, alu32_ctr, shift32_ctr, byte_select_ctr.

module control_logic(op, func, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, BranchEQZ,
                    BranchNEZ, JumpR, Jump, JumpAL, ExtOp, LoadExtOp, MemRead, alu32_ctr,
                    shift32_ctr, byte_select, execute_ctr);
    input wire  [0:5]   op;
    input wire  [0:5]   func;
    output wire         RegDst;
    output wire         ALUSrc;
    output wire         MemtoReg;
    output wire         RegWrite;
    output wire         MemWrite;
    output wire         BranchEQZ;
    output wire         BranchNEZ;
    output wire         JumpR;
    output wire         Jump;
    output wire         JumpAL;
    output wire         ExtOp;
    output wire         LoadExtOp;
    output wire         MemRead;
    output wire [3:0]   alu32_ctr;
    output wire [1:0]   shift32_ctr;
    output wire [1:0]   byte_select;
    output wire [1:0]   execute_ctr;

    wire mux_select;
    wire [0:5] op_inv;
    wire nop_over;

    wire MemtoReg_t, RegWrite_t, MemWrite_t, BranchEQZ_t;
    wire BranchNEZ_t, Jump_t, JumpR_t, JumpAL_t;

    // Main Control
    main_control main_ctr(
        .op         (op),
        .RegDst     (RegDst),
        .ALUSrc     (ALUSrc),
        .MemtoReg   (MemtoReg_t),
        .RegWrite   (RegWrite_t),
        .MemWrite   (MemWrite_t),
        .BranchEQZ  (BranchEQZ_t),
        .BranchNEZ  (BranchNEZ_t),
        .JumpR      (JumpR_t),
        .Jump       (Jump_t),
        .JumpAL     (JumpAL_t),
        .ExtOp      (ExtOp),
        .LoadExtOp  (LoadExtOp),
        .MemRead    (MemRead)
    );

    // Execution Unit Control
    execution_unit_ctr exec_unit(
        .op         (op),
        .func       (func),
        .mux_select (mux_select),
        .execute_ctr(execute_ctr)
    );

    // ALU32 Unit Control
    alu32_unit_ctr alu_unit(
        .op         (op),
        .func       (func),
        .mux_select (mux_select),
        .alu32_ctr  (alu32_ctr)
    );

    // Shift32 Unit Control
    shift32_unit_ctr shift_unit(
        .op         (op),
        .func       (func),
        .mux_select (mux_select),
        .shift32_ctr(shift32_ctr)
    );

    // Byte Select Control
    byte_select_ctr byte_sel(
        .op         (op),
        .byte_select(byte_select)
    );

    // R-type vs I-type Select
    assign op_inv = ~op;
    and_gate_6to1 and_r_type(op_inv[0], op_inv[1], op_inv[2], op_inv[3], op_inv[4], op_inv[5], mux_select);

    // NOP Override
    assign nop_over = (func == 6'h15 & op == 6'h00) ? 1'b1 : 1'b0;
    assign MemtoReg = nop_over ? 1'b0 : MemtoReg_t;
    assign RegWrite = nop_over ? 1'b0 : RegWrite_t;
    assign MemWrite = nop_over ? 1'b0 : MemWrite_t;
    assign BranchEQZ = nop_over ? 1'b0 : BranchEQZ_t;
    assign BranchNEZ = nop_over ? 1'b0 : BranchNEZ_t;
    assign Jump = nop_over ? 1'b0 : Jump_t;
    assign JumpR = nop_over ? 1'b0 : JumpR_t;
    assign JumpAL = nop_over ? 1'b0 : JumpAL_t;

endmodule