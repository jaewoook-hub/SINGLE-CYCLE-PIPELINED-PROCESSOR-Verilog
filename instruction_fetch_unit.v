// Instruction Fetch Unit
// External instruction memory

module instruction_fetch_unit(clk, rst, branch_enable, Jump, JumpR, JumpAL, imm26,
                              pc_4_in, pc_we, busA, pc_4_out, pc_out);
    input wire          clk;
    input wire          rst;
    input wire          pc_we;
    input wire [0:31]   busA;
    input wire          Jump;
    input wire          JumpR;
    input wire          JumpAL;
    input wire          branch_enable;
    input wire [0:29]   pc_4_in;
    input wire [0:25]   imm26;
    output wire [0:29]  pc_4_out;
    output wire [0:31]  pc_out;

    wire [0:29] pc_4;
    wire [0:29] pc_branch_temp;
    wire [0:29] pc_jump_temp;
    wire [0:31] pc_in;

    wire [0:31] branch_offset;
    wire [0:29] branch_target;
   
    wire [0:29] jump_target;
    wire [0:25] j_target_26;
    wire [0:29] j_target_30;
    wire [0:29] j_target_30_t;
    wire [0:31] jr_target_32;
    wire [0:29] jr_target_30;
    wire        jump_enable;

    // Program Counter
    assign pc_in = {pc_jump_temp, 2'b00};

    program_counter pc_unit(
        .clk        (clk),
        .rst        (rst),
        .pc_we      (pc_we),
        .addr_in    (pc_in),
        .addr_out   (pc_out)
    );

    // PC Increment
    simple_adder30 pc_inc(
        .A  (pc_out[0:29]),
        .B  (30'h1),
        .sum(pc_4)
    );

    assign pc_4_out = pc_4;

    // Branch Operations
    assign branch_offset = {{16{imm26[10]}}, imm26[10:25]};

    simple_adder30 branch_calc(
        .A  (pc_4_in),
        .B  (branch_offset[0:29]),
        .sum(branch_target)
    );

    assign pc_branch_temp = (branch_enable) ? branch_target : pc_4;

    // Jump Operations
    assign j_target_26 = imm26;
    assign j_target_30_t = {{6{j_target_26[0]}}, j_target_26[0:23]};

    simple_adder30 j_jump_calc(
        .A  (j_target_30_t),
        .B  (pc_4_in),
        .sum(j_target_30)
    );

    assign jr_target_32 = busA;
    assign jr_target_30 = jr_target_32[0:29];

    assign jump_target = (JumpR) ? jr_target_30 : j_target_30;

    or_gate_3to1 jump_en_or(Jump, JumpR, JumpAL, jump_enable);
    assign pc_jump_temp = (jump_enable) ? jump_target : pc_branch_temp;

endmodule
