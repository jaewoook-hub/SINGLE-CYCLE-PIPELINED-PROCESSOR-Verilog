// Forwarding Unit
// Control forwarding for BusA and BusB for RAW hazards in the pipeline
// Controls
// 00 -- no fw
// 01 -- 1-stage fw
// 10 -- 2-stage fw
// 11 -- no fw (X)

module forwarding_unit(EXMEM_RegWrite, EXMEM_DestReg, IDEX_RegRs, IDEX_RegRt, IDEX_MemWrite,
                       MEMWB_RegWrite, MEMWB_DestReg, Forward_A, Forward_B, ALUSrc);

    input wire [0:4] IDEX_RegRs;
    input wire [0:4] IDEX_RegRt;
    input wire       IDEX_MemWrite;
    input wire [0:4] EXMEM_DestReg;
    input wire       EXMEM_RegWrite;
    input wire [0:4] MEMWB_DestReg;
    input wire       MEMWB_RegWrite;
    input wire       ALUSrc;
    output wire[0:1] Forward_A;
    output wire[0:1] Forward_B;

    wire    dest_exmem_zero;
    wire    dest_memwb_zero;

    // Forwarding A Signals
    wire [0:4] reg_exmem_comp_a;
    wire       reg_exmem_comp_a_1;
    wire [0:4] reg_memwb_comp_a;
    wire       reg_memwb_comp_a_1;

    // Forwarding B Signals
    wire [0:4] reg_exmem_comp_b;
    wire       reg_exmem_comp_b_1;
    wire [0:4] reg_memwb_comp_b;
    wire       reg_memwb_comp_b_1;
    
    // Zero Register Check
    or_gate_5to1 exmem_zero_reg(EXMEM_DestReg[0], EXMEM_DestReg[1],
                                EXMEM_DestReg[2], EXMEM_DestReg[3],
                                EXMEM_DestReg[4], dest_exmem_zero); 
    
    or_gate_5to1 memwb_zero_reg(MEMWB_DestReg[0], MEMWB_DestReg[1],
                                MEMWB_DestReg[2], MEMWB_DestReg[3],
                                MEMWB_DestReg[4], dest_memwb_zero);
    
    // Forwarding for BusA
    // 1-stage forwarding   
    xnor_gate_n DestEXMEM_RsIDEX_comp_A[0:4](EXMEM_DestReg, IDEX_RegRs, reg_exmem_comp_a);
    
    and_gate_5to1 EXMEM_comp_consolidate_A(reg_exmem_comp_a[0], reg_exmem_comp_a[1],
                                           reg_exmem_comp_a[2], reg_exmem_comp_a[3],
                                           reg_exmem_comp_a[4], reg_exmem_comp_a_1);
    
    and_gate_3to1 FWA0_gen(dest_exmem_zero, reg_exmem_comp_a_1, EXMEM_RegWrite, Forward_A[1]);

    // 2-stage forwarding
    xnor_gate_n DestMEMWB_RsIDEX_comp_A[0:4](MEMWB_DestReg, IDEX_RegRs, reg_memwb_comp_a);
    
    and_gate_5to1 MEMWB_comp_consolidate_A(reg_memwb_comp_a[0], reg_memwb_comp_a[1],
                                           reg_memwb_comp_a[2], reg_memwb_comp_a[3],
                                           reg_memwb_comp_a[4], reg_memwb_comp_a_1);
    
    and_gate_4to1 FWA1_gen(~Forward_A[1], dest_memwb_zero, reg_memwb_comp_a_1, MEMWB_RegWrite, Forward_A[0]);

    // Forwarding for BusB
    // 1-stage forwarding   
    xnor_gate_n DestEXMEM_RsIDEX_comp_B[0:4](EXMEM_DestReg, IDEX_RegRt, reg_exmem_comp_b);
    
    and_gate_5to1 EXMEM_comp_consolidate_B(reg_exmem_comp_b[0], reg_exmem_comp_b[1],
                                           reg_exmem_comp_b[2], reg_exmem_comp_b[3],
                                           reg_exmem_comp_b[4], reg_exmem_comp_b_1);
    
    and_gate_3to1 FWB0_gen(dest_exmem_zero, reg_exmem_comp_b_1, EXMEM_RegWrite, Forward_B[1]);

    // 2-stage forwarding
    xnor_gate_n DestMEMWB_RsIDEX_comp_B[0:4](MEMWB_DestReg, IDEX_RegRt, reg_memwb_comp_b);
    
    and_gate_5to1 MEMWB_comp_consolidate_B(reg_memwb_comp_b[0], reg_memwb_comp_b[1],
                                           reg_memwb_comp_b[2], reg_memwb_comp_b[3],
                                           reg_memwb_comp_b[4], reg_memwb_comp_b_1);
    
    and_gate_4to1 FWB1_gen(~Forward_B[1], dest_memwb_zero, reg_memwb_comp_b_1, MEMWB_RegWrite, Forward_B[0]);

endmodule
