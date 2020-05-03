// Execution Unit Control Signals

module execution_unit_ctr(op, func, mux_select, execute_ctr);
    input wire [0:5]    op;
    input wire [0:5]    func;
    input wire          mux_select;
    output wire [1:0]   execute_ctr;

    wire [0:5] op_inv;
    wire [0:5] func_inv;

    wire temp00r, temp01r, temp02r;
    wire temp10r, temp11r;

    wire temp10i, temp11i, temp12i;

    wire [1:0] execute_ctr_r;
    wire [1:0] execute_ctr_i;

    // Inverted inputs
    assign op_inv = ~op;
    assign func_inv = ~func;

    // R-Type Instructions
    // execute_ctr_r[0]
    and_gate_5to1 and00r(func_inv[0], func_inv[1], func_inv[2], func[3], func_inv[5], temp00r);
    and_gate_5to1 and01r(func_inv[0], func_inv[1], func_inv[2], func[3], func[4], temp01r);
    and_gate_6to1 and02r(func_inv[0], func[1], func_inv[2], func[3], func[4], func_inv[5], temp02r);
    or_gate_3to1  or00r(temp00r, temp01r, temp02r, execute_ctr_r[0]);

    // execute_ctr_r[1]
    and_gate_6to1 and10r(func_inv[0], func_inv[1], func[2], func[3], func[4], func_inv[5], temp10r);
    and_gate_6to1 and11r(func_inv[0], func[1], func_inv[2], func[3], func[4], func_inv[5], temp11r);
    or_gate_n or10r(temp10r, temp11r, execute_ctr_r[1]);

    // I-Type Instructions
    // execute_ctr_i[0]
    and_gate_6to1 and10i(op_inv[0], op_inv[1], op[2], op[3], op[4], op[5], temp10i);
    and_gate_6to1 and11i(op_inv[0], op[1], op_inv[2], op[3], op_inv[4], op_inv[5], temp11i);
    and_gate_5to1 and12i(op_inv[0], op[1], op_inv[2], op[3], op[4], temp12i);
    or_gate_3to1  or10i(temp10i, temp11i, temp12i, execute_ctr_i[0]);

    // execute_ctr_i[1]
    assign execute_ctr_i[1] = 0;

    // Output Mux
    assign execute_ctr = mux_select ? execute_ctr_r : execute_ctr_i;

endmodule