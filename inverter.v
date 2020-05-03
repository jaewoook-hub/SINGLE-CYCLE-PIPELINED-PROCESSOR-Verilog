module inverter(A, B);
	
	input wire A;
	output wire B;

	assign B = ~A;

endmodule 
