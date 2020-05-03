// Branch Enable Logic
module branch_logic(BEQZ, zero, BNEZ, branch_en); 
	input wire BEQZ;
	input wire BNEZ;
	input wire zero; 
	output wire branch_en; 
	
	wire not_zero; 
	wire and_gate_1;
	wire and_gate_2; 
	
	inverter dut1(
		.A(zero),
		.B(not_zero)
    );		
	
	and_gate_n dut2(
		.a(BEQZ),
		.b(zero),
		.z(and_gate_1)
	);
	
	and_gate_n dut3(
		.a(BNEZ),
		.b(not_zero),
		.z(and_gate_2)
	);
	
	or_gate_n dut4(
		.a(and_gate_1),
		.b(and_gate_2),
		.z(branch_en) 
	); 
	
endmodule