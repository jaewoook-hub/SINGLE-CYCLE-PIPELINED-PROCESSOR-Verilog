// Load Stall Unit
// 1-cycle stall for LW, LH, LB instructions to deal with RAW data hazards

module load_stall_unit(IDEX_MemRead, IDEX_Rt, IFID_Rt, IFID_Rs, kill_mux_sel,
                       IFID_write, PC_write);
    input wire [0:0] IDEX_MemRead;
    input wire [0:4] IDEX_Rt;
    input wire [0:4] IFID_Rt;
    input wire [0:4] IFID_Rs;
    output wire      kill_mux_sel;
    output wire      IFID_write;
    output wire      PC_write;

    wire [0:4] rtrs_comp;
    wire [0:4] rtrt_comp;
    wire       logic1, logic2, raw_dep;
    wire       load_stall;

    // RAW Dependency Check
    xnor_gate_n Rt_Rs_Comparison[0:4](IDEX_Rt, IFID_Rs, rtrs_comp);
    xnor_gate_n Rt_Rt_Comparison[0:4](IDEX_Rt, IFID_Rt, rtrt_comp);

    and_gate_5to1 and_rt_rs(rtrs_comp[0], rtrs_comp[1], rtrs_comp[2],
                            rtrs_comp[3], rtrs_comp[4], logic1);
    and_gate_5to1 and_rt_rt(rtrt_comp[0], rtrt_comp[1], rtrt_comp[2],
                            rtrt_comp[3], rtrt_comp[4], logic2);
    
    or_gate_n raw_or(logic1, logic2, raw_dep);

    // Load Instruction Check
    and_gate_n load_and(raw_dep, IDEX_MemRead, load_stall);

    // Control Signal Outputs
    assign PC_write = ~load_stall;
    assign IFID_write = ~load_stall;
    assign kill_mux_sel = load_stall;

endmodule