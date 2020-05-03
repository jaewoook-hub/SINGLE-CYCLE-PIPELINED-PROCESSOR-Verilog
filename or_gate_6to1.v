// 6-input or gate
module or_gate_6to1(a0, a1, a2, a3, a4, a5, z);
    input wire a0, a1, a2, a3, a4, a5;
    output wire z;

    assign z = (a0 | a1 | a2 | a3 | a4 | a5);
endmodule