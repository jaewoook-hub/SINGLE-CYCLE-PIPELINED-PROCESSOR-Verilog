// Pipelined DLX Processor
// 5-stages
// Supports integer DLX instructions

module pipeline_processor(
    input wire          clk,
    input wire          rst,

    output wire [0:31]  pc,
    input wire  [0:31]  instruction,
    
    output wire        MemWrite,
    output wire [0:31] dmem_addr,  
    output wire [0:1]  byte_select,
    output wire [0:31] dmem_din,   
    input wire  [0:31] dmem_dout     
);
    // Test Signals
    wire [0:29] PC_IF, PC_ID, PC_EX, PC_MEM, PC_WB;

    // Instruction Wires
    wire [0:31] instruction_w0, instruction_w1;
    wire [0:5]  opcode_w0;
    wire [0:5]  funcode_w0;

    // PC Wires
    wire [0:29] pc_4_w0, pc_4_w1, pc_4_w2, pc_4_w3, pc_4_w4;

    // Register Wires
    wire [0:4] Rs_w0, Rs_w1;
    wire [0:4] Rt_w0, Rt_w1;
    wire [0:4] Rd_w0;
    wire [0:4] DestReg_w0, DestReg_w1, DestReg_w2, DestReg_w3;

    // Control Signal Wires
    wire RegDst_w0;
    wire ALUSrc_w0, ALUSrc_w1;
    wire ExtOp_w0, ExtOp_w1;
    wire MemWrite_w0, MemWrite_w1, MemWrite_w2;
    wire BranchEQZ_w0, BranchEQZ_w1, BranchEQZ_w2;
    wire BranchNEZ_w0, BranchNEZ_w1, BranchNEZ_w2;
    wire LoadExtOp_w0, LoadExtOp_w1, LoadExtOp_w2;
    wire MemRead_w0, MemRead_w1, MemRead_w2;
    wire Jump_w0, Jump_w1, Jump_w2;
    wire JumpR_w0, JumpR_w1, JumpR_w2;

    wire JumpAL_w0, JumpAL_w1, JumpAL_w2, JumpAL_w3;
    wire RegWrite_w0, RegWrite_w1, RegWrite_w2, RegWrite_w3;
    wire MemtoReg_w0, MemtoReg_w1, MemtoReg_w2, MemtoReg_w3;

    wire [3:0] alu32_ctr_w0, alu32_ctr_w1;
    wire [1:0] shift32_ctr_w0, shift32_ctr_w1;
    wire [1:0] execute_ctr_w0, execute_ctr_w1;
    wire [1:0] byte_select_w0, byte_select_w1, byte_select_w2;

    // Branch Enable Wires
    wire branch_enable_w;

    // Bus Wires
    wire [0:31] busA_w0, busA_w1, busA_w2;
    wire [0:31] busB_w0, busB_w1;
    wire [0:31] busB_rt_w0, busB_rt_w1;
    wire [0:31] busW_w0;
    wire [0:31] execution_result_w0, execution_result_w1, execution_result_w2;
    wire [0:31] dmem_dout_w0, dmem_dout_w1;
    wire zero_w0, zero_w1;

    // Immediate Wires
    wire [0:25] imm26_w0, imm26_w1, imm26_w2;

    // Hazard Unit Wires
    wire pc_we_w;
    wire IFID_write_w;
    wire IFID_flush_w;  
    wire IDEX_kill_w;
    wire EXMEM_kill_w;

    // Forwarding Unit Wires
    wire [0:1]  ForwardA_w, ForwardB_w;
    wire [0:4]  IDEX_RegRs;
    wire [0:4]  IDEX_RegRt;
    wire        IDEX_MemWrite;
    wire [0:4]  EXMEM_DestReg;
    wire        EXMEM_RegWrite;
    wire [0:31] EXMEM_data;
    wire [0:4]  MEMWB_DestReg;
    wire        MEMWB_RegWrite;
    wire [0:31] MEMWB_data;

/////////////////////////////////////////////////////////////////////////////
    // TEST SIGNALS
    assign PC_IF = pc_4_w0;
    assign PC_ID = pc_4_w1;
    assign PC_EX = pc_4_w2;
    assign PC_MEM = pc_4_w3;
    assign PC_WB = pc_4_w4;

/////////////////////////////////////////////////////////////////////////////
    // Forwarding Unit
    assign IDEX_RegRs = Rs_w1;
    assign IDEX_RegRt = Rt_w1;
    assign IDEX_MemWrite = MemWrite_w1;
    assign EXMEM_DestReg = DestReg_w2;
    assign EXMEM_RegWrite = RegWrite_w2;
    assign EXMEM_data = execution_result_w1;
    assign MEMWB_DestReg = DestReg_w3;
    assign MEMWB_RegWrite = RegWrite_w3;
    assign MEMWB_data = busW_w0;

    forwarding_unit fw_unit(
        .IDEX_RegRs     (IDEX_RegRs),
        .IDEX_RegRt     (IDEX_RegRt),
        .IDEX_MemWrite  (IDEX_MemWrite),
        .EXMEM_DestReg  (EXMEM_DestReg),
        .EXMEM_RegWrite (EXMEM_RegWrite),
        .MEMWB_DestReg  (MEMWB_DestReg),
        .MEMWB_RegWrite (MEMWB_RegWrite),
        .ALUSrc         (ALUSrc_w1),
        .Forward_A      (ForwardA_w),
        .Forward_B      (ForwardB_w)
    );
/////////////////////////////////////////////////////////////////////////////
    // Hazard Detection Unit
    hazard_detect_unit hz_unit(
        .branch_sel     (branch_enable_w),
        .Jump           (Jump_w2),
        .JumpR          (JumpR_w2),
        .JumpAL         (JumpAL_w2),
        .IDEX_MemRead   (MemRead_w1),
        .IDEX_Rt        (Rt_w1),
        .IFID_Rt        (Rt_w0),
        .IFID_Rs        (Rs_w0),
        .IDEX_kill_mux  (IDEX_kill_w),
        .EXMEM_kill_mux (EXMEM_kill_w),
        .IFID_write     (IFID_write_w),
        .IFID_flush     (IFID_flush_w),
        .PC_write       (pc_we_w)
    );

/////////////////////////////////////////////////////////////////////////////
    // IF Stage: Instruction Fetch
    instruction_fetch_unit if_block(
        .clk            (clk),
        .rst            (rst),
        .pc_we          (pc_we_w),
        .busA           (busA_w2),
        .imm26          (imm26_w2),
        .Jump           (Jump_w2),
        .JumpR          (JumpR_w2),
        .JumpAL         (JumpAL_w2),
        .branch_enable  (branch_enable_w),
        .pc_4_in        (pc_4_w3),

        .pc_4_out       (pc_4_w0),
        .pc_out         (pc)
    );
/////////////////////////////////////////////////////////////////////////////
    // IFID Register
    assign instruction_w0 = instruction;

    IFID_Reg if_id(
        .clk            (clk),
        .rst            (rst),
        .we             (IFID_write_w),
        .IFID_flush     (IFID_flush_w),
        .instruction_in (instruction_w0),
        .pc_4_in        (pc_4_w0),

        .instruction_out(instruction_w1),
        .pc_4_out       (pc_4_w1)
    );
/////////////////////////////////////////////////////////////////////////////
    // ID Stage: Instruction Decode and Register File
    assign imm26_w0 = instruction_w1[6:31];
    assign Rs_w0 = instruction_w1[6:10];
    assign Rd_w0 = instruction_w1[16:20];
    assign Rt_w0 = instruction_w1[11:15];

    register_file_unit reg_file(
        .clk            (~clk),
        .rst            (rst),
        .Rs             (Rs_w0),
        .Rd             (Rd_w0),
        .Rt             (Rt_w0),
        .busW           (busW_w0),
        .RegDst         (RegDst_w0),
        .RegWrite       (RegWrite_w3),
        .JumpAL_ID      (JumpAL_w0),
        .JumpAL_WB      (JumpAL_w3),
        .PC_4           (pc_4_w4),
        .WriteReg       (DestReg_w3),
        
        .busA           (busA_w0),
        .busB           (busB_w0),
        .DestReg        (DestReg_w0)
    );

    assign opcode_w0 = instruction_w1[0:5];
    assign funcode_w0 = instruction_w1[26:31];

    control_logic ctr_block(
        .op             (opcode_w0),
        .func           (funcode_w0),

        .RegDst         (RegDst_w0),
        .ALUSrc         (ALUSrc_w0),
        .MemtoReg       (MemtoReg_w0),
        .RegWrite       (RegWrite_w0),
        .MemWrite       (MemWrite_w0),
        .BranchEQZ      (BranchEQZ_w0),
        .BranchNEZ      (BranchNEZ_w0),
        .JumpR          (JumpR_w0),
        .Jump           (Jump_w0),
        .JumpAL         (JumpAL_w0),
        .ExtOp          (ExtOp_w0),
        .LoadExtOp      (LoadExtOp_w0),
        .MemRead        (MemRead_w0),
        .alu32_ctr      (alu32_ctr_w0),
        .shift32_ctr    (shift32_ctr_w0),
        .byte_select    (byte_select_w0),
        .execute_ctr    (execute_ctr_w0) 
        );

    // Notes
    // JumpAL support (jump MEM, store PC_4 WB)
    // Check wires coming backs
/////////////////////////////////////////////////////////////////////////////
    // IDEX Register
    IDEX_Reg id_ex(
        .clk            (clk),
        .rst            (rst),
        .we             (1'b1),
        .kill_control   (IDEX_kill_w),
        .pc_4_in        (pc_4_w1),
        .busA_in        (busA_w0),
        .busB_in        (busB_w0),
        .imm26_in       (imm26_w0),
        .rt_in          (Rt_w0),
        .rs_in          (Rs_w0),
        .DestReg_in     (DestReg_w0),
        .ALUSrc_in      (ALUSrc_w0),
        .MemtoReg_in    (MemtoReg_w0),
        .RegWrite_in    (RegWrite_w0),
        .MemWrite_in    (MemWrite_w0),
        .BranchEQZ_in   (BranchEQZ_w0),
        .BranchNEZ_in   (BranchNEZ_w0),
        .JumpR_in       (JumpR_w0),
        .Jump_in        (Jump_w0),
        .JumpAL_in      (JumpAL_w0),
        .ExtOp_in       (ExtOp_w0),
        .LoadExtOp_in   (LoadExtOp_w0),
        .MemRead_in     (MemRead_w0),
        .alu32_ctr_in   (alu32_ctr_w0),
        .shift32_ctr_in (shift32_ctr_w0),
        .byte_select_in (byte_select_w0),
        .execute_ctr_in (execute_ctr_w0),

        .pc_4           (pc_4_w2),
        .busA           (busA_w1),
        .busB           (busB_w1),
        .imm26          (imm26_w1),
        .rt             (Rt_w1),
        .rs             (Rs_w1),
        .DestReg        (DestReg_w1),
        .ALUSrc         (ALUSrc_w1),
        .MemtoReg       (MemtoReg_w1),
        .RegWrite       (RegWrite_w1),
        .MemWrite       (MemWrite_w1),
        .BranchEQZ      (BranchEQZ_w1),
        .BranchNEZ      (BranchNEZ_w1),
        .JumpR          (JumpR_w1),
        .Jump           (Jump_w1),
        .JumpAL         (JumpAL_w1),
        .ExtOp          (ExtOp_w1),
        .LoadExtOp      (LoadExtOp_w1),
        .MemRead        (MemRead_w1),
        .alu32_ctr      (alu32_ctr_w1),
        .shift32_ctr    (shift32_ctr_w1),
        .byte_select    (byte_select_w1),
        .execute_ctr    (execute_ctr_w1)
    );
/////////////////////////////////////////////////////////////////////////////
    // EX Stage: Execution Stage
    execution_unit_block exec_block(
        .busA           (busA_w1),
        .busB           (busB_w1),
        .alu32_ctr      (alu32_ctr_w1),
        .shift32_ctr    (shift32_ctr_w1),
        .execute_ctr    (execute_ctr_w1),
        .imm16          (imm26_w1[10:25]),
        .BranchEQZ      (BranchEQZ_w1),
        .BranchNEZ      (BranchNEZ_w1),
        .ExtOp          (ExtOp_w1),
        .ALUSrc         (ALUSrc_w1),
        .ForwardA       (ForwardA_w),
        .ForwardB       (ForwardB_w),
        .EXMEM_data     (EXMEM_data),
        .MEMWB_data     (MEMWB_data),
        
        .result         (execution_result_w0),
        .zero           (zero_w0),
        .busB_Rt        (busB_rt_w0)
    );

    //Notes
    // Connect EXMEM_data and MEMWB_data
/////////////////////////////////////////////////////////////////////////////
    // EXMEM Register
    EXMEM_Reg ex_mem(
        .clk                (clk),
        .rst                (rst),
        .we                 (1'b1),
        .kill_control       (EXMEM_kill_w),
        .pc_4_in            (pc_4_w2),
        .execution_result_in(execution_result_w0),
        .busA_in            (busA_w1),
        .busB_in            (busB_rt_w0),
        .imm26_in           (imm26_w1),
        .DestReg_in         (DestReg_w1),
        .zero_in            (zero_w0),  
        .MemtoReg_in        (MemtoReg_w1),
        .RegWrite_in        (RegWrite_w1),
        .MemWrite_in        (MemWrite_w1),
        .BranchEQZ_in       (BranchEQZ_w1),
        .BranchNEZ_in       (BranchNEZ_w1),
        .JumpR_in           (JumpR_w1),
        .Jump_in            (Jump_w1),
        .JumpAL_in          (JumpAL_w1),
        .LoadExtOp_in       (LoadExtOp_w1),
        .MemRead_in         (MemRead_w1),
        .byte_select_in     (byte_select_w1),

        .pc_4               (pc_4_w3),
        .execution_result   (execution_result_w1),
        .busA               (busA_w2),
        .busB               (busB_rt_w1),
        .imm26              (imm26_w2),
        .DestReg            (DestReg_w2),
        .zero               (zero_w1),  
        .MemtoReg           (MemtoReg_w2),
        .RegWrite           (RegWrite_w2),
        .MemWrite           (MemWrite_w2),
        .BranchEQZ          (BranchEQZ_w2),
        .BranchNEZ          (BranchNEZ_w2),
        .JumpR              (JumpR_w2),
        .Jump               (Jump_w2),
        .JumpAL             (JumpAL_w2),
        .LoadExtOp          (LoadExtOp_w2),
        .MemRead            (MemRead_w2),
        .byte_select        (byte_select_w2)   
    );
/////////////////////////////////////////////////////////////////////////////
    // MEM Stage: Data Memory Interface, Load Extend and Branch Decision
    assign dmem_addr = execution_result_w1;
    assign dmem_din = busB_rt_w1;
    assign MemWrite = MemWrite_w2;
    assign byte_select = byte_select_w2;

    load_extend_unit dout_extend(
        .A8                 (dmem_dout[0:7]),
        .A16                (dmem_dout[0:15]),
        .A32                (dmem_dout),
        .LoadExtOp          (LoadExtOp_w2),
        .byte_sel           (byte_select_w2),

        .A32_out            (dmem_dout_w0)
    );

    branch_logic branch_en_logic(
        .BEQZ               (BranchEQZ_w2),
        .BNEZ               (BranchNEZ_w2),
        .zero               (zero_w1),

        .branch_en          (branch_enable_w)
    );
/////////////////////////////////////////////////////////////////////////////
    // MEMWB Register
    MEMWB_Reg mem_wb(
        .clk                (clk),
        .rst                (rst),
        .we                 (1'b1),

        .pc_4_in            (pc_4_w3),
        .MemtoReg_in        (MemtoReg_w2),
        .RegWrite_in        (RegWrite_w2),
        .JumpAL_in          (JumpAL_w2),
        .data_read_in       (dmem_dout_w0),
        .execution_result_in(execution_result_w1),
        .DestReg_in         (DestReg_w2),

        .pc_4               (pc_4_w4),
        .MemtoReg           (MemtoReg_w3),
        .RegWrite           (RegWrite_w3),
        .JumpAL             (JumpAL_w3),
        .data_read          (dmem_dout_w1),
        .execution_result   (execution_result_w2),
        .DestReg            (DestReg_w3)
    );
/////////////////////////////////////////////////////////////////////////////
    // WB Stage: Write back Mux
    assign busW_w0 = (MemtoReg_w3) ? dmem_dout_w1 : execution_result_w2;

/////////////////////////////////////////////////////////////////////////////


endmodule