// Hazard Detection Unit
// Produces control signals to handle data hazards, branch harzards
// and MUL/MULU stalls
// Branches predict always-not-taken
// Support Jump instructions

module hazard_detect_unit(branch_sel, Jump, JumpR, JumpAL, IDEX_MemRead, IDEX_Rt, IFID_Rt, IFID_Rs, 
                          IDEX_kill_mux, EXMEM_kill_mux, IFID_write, IFID_flush, PC_write);

    input wire       branch_sel;
    input wire       Jump;
    input wire       JumpR;
    input wire       JumpAL;
    input wire [0:0] IDEX_MemRead;
    input wire [0:4] IDEX_Rt;
    input wire [0:4] IFID_Rt;
    input wire [0:4] IFID_Rs;
    output wire      IDEX_kill_mux;
    output wire      EXMEM_kill_mux;
    output wire      IFID_write;
    output wire      IFID_flush;
    output wire      PC_write;

    wire load_kill;

    // Load Stall Unit
    load_stall_unit load_control(
        .IDEX_MemRead   (IDEX_MemRead),
        .IDEX_Rt        (IDEX_Rt),
        .IFID_Rt        (IFID_Rt),
        .IFID_Rs        (IFID_Rs),
        .kill_mux_sel   (load_kill),
        .IFID_write     (IFID_write),
        .PC_write       (PC_write)
    );

    // Kill and flush ouputs
    assign IFID_flush = (branch_sel | Jump | JumpAL | JumpR);
    assign EXMEM_kill_mux = (branch_sel | Jump | JumpAL | JumpR);
    assign IDEX_kill_mux = (branch_sel | Jump | JumpAL | JumpR | load_kill);

endmodule