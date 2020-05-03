// n or gate
module or_gate_n(a, b, z);
    parameter n = 1;
    input wire[n-1:0] a;
    input wire[n-1:0] b;
    output wire[n-1:0] z;

    assign z = a | b;
endmodule
