// 1-bit full adder
module adder1(A, B, cin, sum, cout);
    input wire A;
    input wire B;
    input wire cin;
    output wire sum;
    output wire cout;

    wire log1, log2, log3;


    // Summation Logic
    xor_gate_n xor1(
        .a(A),
        .b(B),
        .z(log1)
    );
    xor_gate_n xor2(
        .a(log1),
        .b(cin),
        .z(sum)
    );

    //Carry out logic
    and_gate_n and1(
        .a(log1),
        .b(cin),
        .z(log2)
    );

    and_gate_n and2(
        .a(A),
        .b(B),
        .z(log3)
    );

    or_gate_n or1(
        .a(log2),
        .b(log3),
        .z(cout)
    );


endmodule