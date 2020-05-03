// Load Extend Unit
// Sign or zero extend Byte and Halfword loads

module load_extend_unit(A8, A16, A32, LoadExtOp, byte_sel, A32_out);
	input wire [7:0] 	A8; 
	input wire [15:0] 	A16;
	input wire [31:0]	A32;
	input wire 		 	LoadExtOp;
	input wire [1:0] 	byte_sel;
	output reg [31:0] 	A32_out;
	
	wire [31:0] sign_ext_8bit;
	wire [31:0] zero_ext_8bit;
	wire [31:0] A8_t;
	
	wire [31:0] sign_ext_16bit;
	wire [31:0] zero_ext_16bit;
	wire [31:0] A16_t;

	// 8-bit operation
	sign_ext_8to32 sext8(
		.cin		(A8),
		.cout		(sign_ext_8bit)
    );

	zero_ext_8to32 zext8(
		.cin		(A8),
		.cout		(zero_ext_8bit)
    );

	assign A8_t = LoadExtOp ? sign_ext_8bit : zero_ext_8bit;

	// 16-bit operation
	sign_ext_16to32 sext16(
		.cin		(A16),
		.cout		(sign_ext_16bit)
    );

	zero_ext_16to32 zext16(
		.cin		(A16),
		.cout		(zero_ext_16bit)
    );

	assign A16_t = LoadExtOp ? sign_ext_16bit : zero_ext_16bit;
	
	// Output Mux
	always @(*) 
	begin
		case (byte_sel)
			2'b00 : A32_out = A8_t;
			2'b01 : A32_out = A16_t;
			2'b10 : A32_out = 32'b0;
			2'b11 : A32_out = A32;
		endcase
	end
	
endmodule
	