// Shift32 Control Signals

// GET RID OF MUX SELECT, ADD AT CONTROL_LOGIC LEVEL
module shift32_unit_ctr(op, func, mux_select, shift32_ctr);
    input wire [0:5]    op;
    input wire [0:5]    func;
    input wire          mux_select;
    output wire [1:0]   shift32_ctr;

    wire [0:5] op_inv;
    wire [0:5] func_inv;

    wire temp00_i, temp01_i;
    wire temp10_i;

    wire [1:0] shift32_ctr_r;
    wire [1:0] shift32_ctr_i;

    // Inverted inputs
    assign op_inv = ~op;
    assign func_inv = ~func;

    // R-Type Instructions
    // shift32_ctr_r[0]
    and_gate_3to1 and00_r(func[3], func[4], func_inv[5], shift32_ctr_r[0]);

    // shift32_ctr_r[1]
    and_gate_3to1 and10_r(func[3], func[4], func[5], shift32_ctr_r[1]);

    // I-Type Instructions
    // shift32_ctr_i[0]
    and_gate_6to1 and00_i(op_inv[0], op_inv[1], op[2], op[3], op[4], op[5], temp00_i);
    and_gate_6to1 and01_i(op_inv[0], op[1], op_inv[2], op[3], op[4], op_inv[5], temp01_i);
    or_gate_n or00_i(temp00_i, temp01_i, shift32_ctr_i[0]);

    // shift32_ctr_i[1]
    and_gate_6to1 and10_i(op_inv[0], op[1], op_inv[2], op[3], op[4], op[5], temp10_i);
    or_gate_n or10_i(temp00_i, temp10_i, shift32_ctr_i[1]);

    // Output Mux
    assign shift32_ctr = mux_select ? shift32_ctr_r : shift32_ctr_i;

endmodule