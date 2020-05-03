// MEMWB Register

module MEMWB_Reg(
    input wire          clk,
    input wire          rst,
    input wire          we,

    input wire [0:29]   pc_4_in,
    input wire          MemtoReg_in,
    input wire          RegWrite_in,
    input wire          JumpAL_in,
    input wire [0:31]   data_read_in,
    input wire [0:31]   execution_result_in,
    input wire [0:4]    DestReg_in,

    output wire [0:29]  pc_4,
    output wire         MemtoReg,
    output wire         RegWrite,
    output wire         JumpAL,
    output wire [0:31]  data_read,
    output wire [0:31]  execution_result,
    output wire [0:4]   DestReg
);
    dff_n dff0[0:29](clk, rst, we, pc_4_in, pc_4);
    dff_n dff1(clk, rst, we, MemtoReg_in, MemtoReg);
    dff_n dff2(clk, rst, we, RegWrite_in, RegWrite);
    dff_n dff3[0:31](clk, rst, we, data_read_in, data_read);    
    dff_n dff4[0:31](clk, rst, we, execution_result_in, execution_result);
    dff_n dff5[0:4](clk, rst, we, DestReg_in, DestReg);
    dff_n dff6(clk, rst, we, JumpAL_in, JumpAL);

endmodule
