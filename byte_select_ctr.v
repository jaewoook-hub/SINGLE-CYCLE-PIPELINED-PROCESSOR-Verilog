// Byte Select Control Signals

module byte_select_ctr(op, byte_select);
    input wire [0:5] op;
    output wire [1:0] byte_select;

    wire [0:5] op_inv;

    // byte_select
    assign byte_select[0] = op[5];
    and_gate_n and0(op[4], op[5], byte_select[1]);
    
endmodule