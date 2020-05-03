// EXMEM Register

module EXMEM_Reg(
    input wire          clk,
    input wire          rst,
    input wire          we,
    input wire          kill_control,

    input wire [0:29]   pc_4_in,
    input wire [0:31]   execution_result_in,
    input wire [0:31]   busA_in,
    input wire [0:31]   busB_in,
    input wire [0:25]   imm26_in,
    input wire [0:4]    DestReg_in,
    input wire          zero_in,
    input wire          MemtoReg_in,
    input wire          RegWrite_in,
    input wire          MemWrite_in,
    input wire          BranchEQZ_in,
    input wire          BranchNEZ_in,
    input wire          JumpR_in,
    input wire          Jump_in,
    input wire          JumpAL_in,
    input wire          LoadExtOp_in,
    input wire          MemRead_in,
    input wire [1:0]    byte_select_in,
    
    output wire [0:29]   pc_4,
    output wire [0:31]   execution_result,
    output wire [0:31]   busA,
    output wire [0:31]   busB,
    output wire [0:25]   imm26,
    output wire [0:4]    DestReg,
    output wire          zero,
    output wire          MemtoReg,
    output wire          RegWrite,
    output wire          MemWrite,
    output wire          BranchEQZ,
    output wire          BranchNEZ,
    output wire          JumpR,
    output wire          Jump,
    output wire          JumpAL,
    output wire          LoadExtOp,
    output wire          MemRead,
    output wire [1:0]    byte_select
);
    wire MemtoReg_t;
    wire RegWrite_t;
    wire MemWrite_t;
    wire BranchEQZ_t;
    wire BranchNEZ_t;
    wire JumpR_t;
    wire Jump_t;
    wire JumpAL_t;
    wire MemRead_t;

    dff_n dff0[0:29](clk, rst, we, pc_4_in, pc_4);
    dff_n dff1[0:31](clk, rst, we, execution_result_in, execution_result);
    dff_n dff2A[0:31](clk, rst, we, busA_in, busA);
    dff_n dff2B[0:31](clk, rst, we, busB_in, busB);
    dff_n dff3[0:25](clk, rst, we, imm26_in, imm26);
    dff_n dff4[0:4](clk, rst, we, DestReg_in, DestReg);
    dff_n dff5(clk, rst, we, zero_in, zero);

    dff_n dff18(clk, rst, we, LoadExtOp_in, LoadExtOp);

    dff_n dff9(clk, rst, we, MemtoReg_t, MemtoReg);
    dff_n dff10(clk, rst, we, RegWrite_t, RegWrite);
    dff_n dff11(clk, rst, we, MemWrite_t, MemWrite);
    dff_n dff12(clk, rst, we, BranchEQZ_t, BranchEQZ);
    dff_n dff13(clk, rst, we, BranchNEZ_t, BranchNEZ);
    dff_n dff14(clk, rst, we, Jump_t, Jump);
    dff_n dff15(clk, rst, we, JumpR_t, JumpR);
    dff_n dff16(clk, rst, we, JumpAL_t, JumpAL);
    dff_n dff19(clk, rst, we, MemRead_t, MemRead);
    
    dff_n dff22[0:1](clk, rst, we, byte_select_in, byte_select);

    // Kill Mux
    assign MemtoReg_t = (kill_control) ? 1'b0 : MemtoReg_in;
    assign RegWrite_t = (kill_control) ? 1'b0 : RegWrite_in;
    assign MemWrite_t = (kill_control) ? 1'b0 : MemWrite_in;
    assign BranchEQZ_t = (kill_control) ? 1'b0 : BranchEQZ_in;
    assign BranchNEZ_t = (kill_control) ? 1'b0 : BranchNEZ_in;
    assign Jump_t = (kill_control) ? 1'b0 : Jump_in;
    assign JumpR_t = (kill_control) ? 1'b0 : JumpR_in;
    assign JumpAL_t = (kill_control) ? 1'b0 : JumpAL_in;
    assign MemRead_t = (kill_control) ? 1'b0 : MemRead_in;

endmodule