// Opcode Decoder
// 6-input and gate

module opcode_decode(op, z);
    input wire [0:5] op;
    output wire z;

    and_gate_6to1 op_dec(op[0], op[1], op[2], op[3], op[4], op[5], z);
endmodule