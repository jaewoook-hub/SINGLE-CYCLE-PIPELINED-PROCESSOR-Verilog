// 5-input and gate
module and_gate_5to1(a0, a1, a2, a3, a4, z);
    input wire a0, a1, a2, a3, a4;
    output wire z;

    assign z = (a0 & a1 & a2 & a3 & a4);
endmodule