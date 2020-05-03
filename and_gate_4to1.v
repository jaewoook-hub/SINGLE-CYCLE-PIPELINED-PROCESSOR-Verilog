// 4-input and gate
module and_gate_4to1(a0, a1, a2, a3, z);
    input wire a0, a1, a2, a3;
    output wire z;

    assign z = (a0 & a1 & a2 & a3);
endmodule