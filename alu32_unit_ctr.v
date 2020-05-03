// ALU32 Control Signals

module alu32_unit_ctr(op, func, mux_select, alu32_ctr);
    input wire [0:5]    op;
    input wire [0:5]    func;
    input wire          mux_select;
    output wire [3:0]   alu32_ctr;

    wire [0:5] op_inv;
    wire [0:5] func_inv;

    wire temp00_r, temp01_r, temp02_r;
    wire temp10_r, temp11_r, temp12_r, temp13_r, temp14_r;
    wire temp20_r, temp21_r, temp22_r, temp23_r, temp24_r, temp25_r;
    wire temp30_r, temp31_r, temp32_r, temp33_r, temp34_r;

    wire temp00_i, temp01_i, temp02_i;
    wire temp10_i, temp11_i, temp12_i, temp13_i, temp14_i, temp15_i, temp16_i;
    wire temp20_i, temp21_i, temp22_i, temp23_i, temp24_i, temp25_i;
    wire temp30_i, temp31_i, temp32_i, temp33_i, temp34_i;

    wire [3:0] alu32_ctr_r;
    wire [3:0] alu32_ctr_i;

    // Inverted inputs
    assign op_inv = ~op;
    assign func_inv = ~func;

    // R-Type Instructions
    // alu32_ctr_r[0]
    and_gate_3to1 and00_r(func_inv[2], func_inv[3], func[4], temp00_r);
    or_gate_n or00_r(temp00_r, func[2], temp01_r);
    and_gate_n and01_r(func[0], func_inv[1], temp02_r);
    and_gate_n and_02_r(temp01_r, temp02_r, alu32_ctr_r[0]);

    // alu32_ctr_r[1]
    and_gate_n and10_r(func[0], func_inv[1], temp10_r);
    and_gate_3to1 and11_r(func_inv[2], func[3], func_inv[4], temp11_r);
    and_gate_3to1 and12_r(func[2], func_inv[3], func[4], temp12_r);
    and_gate_3to1 and13_r(func[2], func[3], func_inv[4], temp13_r);
    or_gate_3to1  or10_r(temp11_r, temp12_r, temp13_r, temp14_r);
    and_gate_n and14_r(temp10_r, temp14_r, alu32_ctr_r[1]);

    // alu32_ctr_r[2]
    and_gate_n and20_r(func[0], func_inv[1], temp20_r);
    and_gate_4to1 and21_r(func_inv[2], func[3], func_inv[4], func[5], temp21_r);
    and_gate_4to1 and22_r(func_inv[2], func[3], func[4], func_inv[5], temp22_r);
    and_gate_3to1 and23_r(func[2], func_inv[3], func_inv[4], temp23_r);
    and_gate_3to1 and24_r(func[2], func[3], func_inv[4], temp24_r);
    or_gate_4to1 or20_r(temp21_r, temp22_r, temp23_r, temp24_r, temp25_r);
    and_gate_n and25_r(temp20_r, temp25_r, alu32_ctr_r[2]);

    // alu32_ctr_r[3]
    and_gate_n and30_r(func[0], func_inv[1], temp30_r);
    and_gate_4to1 and31_r(func[2], func_inv[3], func_inv[4], func[5], temp31_r);
    and_gate_4to1 and32_r(func[2], func_inv[3], func[4], func[5], temp32_r);
    and_gate_4to1 and33_r(func[2], func[3], func_inv[4], func[5], temp33_r);
    or_gate_3to1  or30_r(temp31_r, temp32_r, temp33_r, temp34_r);
    and_gate_n and34_r(temp30_r, temp34_r, alu32_ctr_r[3]);

    // I-Type Instructions
    // alu32_ctr_i[0]
    and_gate_5to1 and00_i(op_inv[0], op_inv[1], op[2], op_inv[3], op[4], temp00_i);
    and_gate_3to1 and01_i(op_inv[0], op[1], op[2], temp01_i);
    or_gate_n nor00_i(temp00_i, temp01_i, alu32_ctr_i[0]);

    // alu32_ctr_i[1]
    and_gate_n and10_i(op_inv[0], op_inv[1], temp10_i);
    and_gate_3to1 and11_i(op[2], op[3], op_inv[4], temp11_i);
    and_gate_n and12_i(temp10_i, temp11_i, temp12_i);
    and_gate_n and13_i(op_inv[0], op[1], temp13_i);
    and_gate_3to1 and14_i(op[2], op_inv[3], op[4], temp14_i);
    or_gate_n or12_i(temp14_i, temp11_i, temp15_i);
    and_gate_n and15_i(temp13_i, temp15_i, temp16_i);
    or_gate_n or16_i(temp12_i, temp16_i, alu32_ctr_i[1]);

    // alu32_ctr_i[2]
    and_gate_4to1 and20_i(op_inv[0], op_inv[1], op[2], op[3], temp20_i);
    and_gate_n and21_i(op_inv[4], op[5], temp21_i);
    and_gate_n and22_i(op[4], op_inv[5], temp22_i);
    or_gate_n  or20_i(temp21_i, temp22_i, temp23_i);
    and_gate_n and23_i(temp20_i, temp23_i, temp24_i); 
    and_gate_4to1 and24_i(op_inv[0], op[1], op[2], op_inv[4], temp25_i);
    or_gate_n or21_i(temp24_i, temp25_i, alu32_ctr_i[2]);

    // alu32_ctr_i[3]
    and_gate_3to1 and30_i(op_inv[0], op[1], op[2], temp30_i);
    and_gate_n and31_i(op_inv[3], op[5], temp31_i);
    and_gate_3to1 and32_i(op[3], op_inv[4], op[5], temp32_i);
    or_gate_n or30_i(temp31_i, temp32_i, temp34_i);
    and_gate_n and33_i(temp30_i, temp34_i, alu32_ctr_i[3]);

    // Output Mux
    assign alu32_ctr = mux_select ? alu32_ctr_r : alu32_ctr_i;
    
endmodule