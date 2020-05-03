// Zero Extend 8-bit to 32-bit
module zero_ext_8to32 (cin, cout);
	parameter 	n = 8;
	input wire 	[n-1:0] cin;
	output reg	[31:0] cout;
	
	always @ (cin) 
	begin
		cout[31:0] <= {{(32-n){1'b0}}, cin[n-1:0]};
	end
endmodule
