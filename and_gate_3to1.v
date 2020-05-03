// 3-input and gate
module and_gate_3to1(a0, a1, a2, z);
    input wire a0, a1, a2;
    output wire z;

    assign z = (a0 & a1 & a2);
endmodule