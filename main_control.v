// Main Control Block
// Generates control signals

module main_control(op, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, BranchEQZ,
                    BranchNEZ, JumpR, Jump, JumpAL, ExtOp, LoadExtOp, MemRead);
    input wire  [0:5]   op;
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

    wire [0:5] op_inv;
    wire [0:5] op_R0, op_R1, op_BEQZ, op_BNEZ, op_ADDI, op_ADDUI, op_SUBI, op_SUBUI;
    wire [0:5] op_ANDI, op_ORI, op_XORI, op_LHI, op_JR, op_JALR, op_SLLI, op_SRLI;
    wire [0:5] op_SRAI, op_SEQI, op_SNEI, op_SLTI, op_SGTI, op_SLEI, op_SGEI, op_LB;
    wire [0:5] op_LH, op_LW, op_LBU, op_LHU, op_SB, op_SH, op_SW, op_J, op_JAL;

    wire sig_R0, sig_R1, sig_BEQZ, sig_BNEZ, sig_ADDI, sig_ADDUI, sig_SUBI, sig_SUBUI;
    wire sig_ANDI, sig_ORI, sig_XORI, sig_LHI, sig_JR, sig_JALR, sig_SLLI, sig_SRLI;
    wire sig_SRAI, sig_SEQI, sig_SNEI, sig_SLTI, sig_SGTI, sig_SLEI, sig_SGEI, sig_LB;
    wire sig_LH, sig_LW, sig_LBU, sig_LHU, sig_SB, sig_SH, sig_SW, sig_J, sig_JAL;

    wire RegWrite_0, RegWrite_1, RegWrite_2, RegWrite_3, RegWrite_4; 
    wire ExtOp_0, ExtOp_1, ExtOp_2, ExtOp_3;

    // Inverted Input
    assign op_inv = ~op;

    // Opcode Signals
    assign op_R0 = op_inv;
    assign op_R1 = {op_inv[0:4], op[5]};
    assign op_BEQZ = {op_inv[0:2], op[3], op_inv[4:5]};
    assign op_BNEZ = {op_inv[0:2], op[3], op_inv[4], op[5]};
    assign op_ADDI = {op_inv[0:1], op[2], op_inv[3:5]};
    assign op_ADDUI = {op_inv[0:1], op[2], op_inv[3:4], op[5]};
    assign op_SUBI = {op_inv[0:1], op[2], op_inv[3], op[4], op_inv[5]};
    assign op_SUBUI = {op_inv[0:1], op[2], op_inv[3], op[4:5]};
    assign op_ANDI = {op_inv[0:1], op[2:3], op_inv[4:5]};
    assign op_ORI = {op_inv[0:1], op[2:3], op_inv[4], op[5]};
    assign op_XORI = {op_inv[0:1], op[2:4], op_inv[5]};
    assign op_LHI = {op_inv[0:1], op[2:5]};
    assign op_JR = {op_inv[0], op[1], op_inv[2:3], op[4], op_inv[5]};
    assign op_JALR = {op_inv[0], op[1], op_inv[2:3], op[4:5]};
    assign op_SLLI = {op_inv[0], op[1], op_inv[2], op[3], op_inv[4:5]};
    assign op_SRLI = {op_inv[0], op[1], op_inv[2], op[3:4], op_inv[5]};
    assign op_SRAI = {op_inv[0], op[1], op_inv[2], op[3:5]};
    assign op_SEQI = {op_inv[0], op[1:2], op_inv[3:5]};
    assign op_SNEI = {op_inv[0], op[1:2], op_inv[3:4], op[5]};
    assign op_SLTI = {op_inv[0], op[1:2], op_inv[3], op[4], op_inv[5]};
    assign op_SGTI = {op_inv[0], op[1:2], op_inv[3], op[4:5]};
    assign op_SLEI = {op_inv[0], op[1:2], op[3], op_inv[4:5]};
    assign op_SGEI = {op_inv[0], op[1:3], op_inv[4], op[5]};
    assign op_LB = {op[0], op_inv[1], op_inv[2:5]};
    assign op_LH = {op[0], op_inv[1], op_inv[2:4], op[5]};
    assign op_LW = {op[0], op_inv[1], op_inv[2:3], op[4:5]};
    assign op_LBU = {op[0], op_inv[1], op_inv[2], op[3], op_inv[4:5]};
    assign op_LHU = {op[0], op_inv[1], op_inv[2], op[3], op_inv[4], op[5]};
    assign op_SB = {op[0], op_inv[1], op[2], op_inv[3:5]};
    assign op_SH = {op[0], op_inv[1], op[2], op_inv[3:4], op[5]};
    assign op_SW = {op[0], op_inv[1], op[2], op_inv[3], op[4:5]};
    assign op_J = {op_inv[0:3], op[4], op_inv[5]};
    assign op_JAL = {op_inv[0:3], op[4:5]};

    // Opcode Decoders
    opcode_decode dec00(op_R0, sig_R0);
    opcode_decode dec01(op_R1, sig_R1);
    opcode_decode dec02(op_BEQZ, sig_BEQZ);
    opcode_decode dec03(op_BNEZ, sig_BNEZ);
    opcode_decode dec04(op_ADDI, sig_ADDI);
    opcode_decode dec05(op_ADDUI, sig_ADDUI);
    opcode_decode dec06(op_SUBI, sig_SUBI);
    opcode_decode dec07(op_SUBUI, sig_SUBUI);
    opcode_decode dec08(op_ANDI, sig_ANDI);
    opcode_decode dec09(op_ORI, sig_ORI);
    opcode_decode dec10(op_XORI, sig_XORI);
    opcode_decode dec11(op_LHI, sig_LHI);
    opcode_decode dec12(op_JR, sig_JR);
    opcode_decode dec13(op_JALR, sig_JALR);
    opcode_decode dec14(op_SLLI, sig_SLLI);
    opcode_decode dec15(op_SRLI, sig_SRLI);
    opcode_decode dec16(op_SRAI, sig_SRAI);
    opcode_decode dec17(op_SEQI, sig_SEQI);
    opcode_decode dec18(op_SNEI, sig_SNEI);
    opcode_decode dec19(op_SLTI, sig_SLTI);
    opcode_decode dec20(op_SGTI, sig_SGTI);
    opcode_decode dec21(op_SLEI, sig_SLEI);
    opcode_decode dec22(op_SGEI, sig_SGEI);
    opcode_decode dec23(op_LB, sig_LB);
    opcode_decode dec24(op_LH, sig_LH);
    opcode_decode dec25(op_LW, sig_LW);
    opcode_decode dec26(op_LBU, sig_LBU);
    opcode_decode dec27(op_LHU, sig_LHU);
    opcode_decode dec28(op_SB, sig_SB);
    opcode_decode dec29(op_SH, sig_SH);
    opcode_decode dec30(op_SW, sig_SW);
    opcode_decode dec31(op_J, sig_J);
    opcode_decode dec32(op_JAL, sig_JAL);

    // RegDst Signal
    nor_gate_n RegDst_nor(sig_R0, sig_R1, RegDst);

    // ALUSrc Signal
    assign ALUSrc = RegDst;

    // MemtoReg Signal
    or_gate_5to1 MemtoReg_or(sig_LB, sig_LH, sig_LW, sig_LBU, sig_LHU, MemtoReg);

    // RegWrite Signal
    or_gate_5to1 RegWrite_or0(sig_R0, sig_R1, sig_ADDI, sig_ADDUI, sig_SUBI, RegWrite_0);
    or_gate_5to1 RegWrite_or1(sig_SUBUI, sig_ANDI, sig_ORI, sig_XORI, sig_LHI, RegWrite_1);
    or_gate_5to1 RegWrite_or2(sig_SLLI, sig_SRLI, sig_SRAI, sig_SEQI, sig_SNEI, RegWrite_2);
    or_gate_5to1 RegWrite_or3(sig_SLTI, sig_SGTI, sig_SLEI, sig_SGEI, sig_LB, RegWrite_3);
    or_gate_5to1 RegWrite_or4(sig_LH, sig_LW, sig_LBU, sig_LHU, sig_JAL, RegWrite_4);
    or_gate_6to1 RegWrite_or5(RegWrite_0, RegWrite_1, RegWrite_2, RegWrite_3, RegWrite_4, sig_JALR, RegWrite);

    // MemWrite Signal
    or_gate_3to1 MemWrite_or(sig_SB, sig_SW, sig_SH, MemWrite);

    // BranchEQZ Signal
    assign BranchEQZ = sig_BEQZ;

    // BranchNEZ Signal
    assign BranchNEZ = sig_BNEZ;

    // JumpR Signal
    or_gate_n JumpR_or(sig_JR, sig_JALR, JumpR);

    // Jump Signal 
    or_gate_n Jump_or(sig_JR, sig_J, Jump);

    // JumpAL Signal
    or_gate_n JumpAL_or(sig_JALR, sig_JAL, JumpAL);

    // ExtOp Signal
    or_gate_5to1 ExtOp_or0(sig_ADDI, sig_SUBI, sig_ANDI, sig_ORI, sig_XORI, ExtOp_0);
    or_gate_5to1 ExtOp_or1(sig_LB, sig_LH, sig_LW, sig_LB, sig_LHU, ExtOp_1);
    or_gate_5to1 ExtOp_or2(sig_SB, sig_SH, sig_SW, sig_SEQI, sig_SNEI, ExtOp_2);
    or_gate_5to1 ExtOp_or3(sig_SLTI, sig_SGTI, sig_SLEI, sig_SGEI, sig_LBU, ExtOp_3);
    or_gate_4to1 ExtOp_or4(ExtOp_0, ExtOp_1, ExtOp_2, ExtOp_3, ExtOp);

    // LoadExtOp Signal
    or_gate_n LoadExOp_or(sig_LB, sig_LH, LoadExtOp);

    // MemRead Signals
    or_gate_5to1 MemRead_or(sig_LB, sig_LH, sig_LW, sig_LBU, sig_LHU, MemRead);

endmodule 