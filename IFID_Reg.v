// IFID Register
// Includes flush support

module IFID_Reg(clk, rst, we, IFID_flush, instruction_in, pc_4_in, 
                instruction_out, pc_4_out);
    input wire         clk;
    input wire         rst;
    input wire         we;
    input wire         IFID_flush;
    input wire  [0:31] instruction_in;
    input wire  [0:29] pc_4_in; 
    output wire [0:31] instruction_out;
    output wire [0:29] pc_4_out; 

    wire flush_control;
    assign flush_control = (rst & (~IFID_flush));

    dff_n dff0[0:31](clk, flush_control, we, instruction_in, instruction_out);
    dff_n dff1[0:29](clk, flush_control, we, pc_4_in, pc_4_out);

endmodule