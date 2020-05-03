// Register File Unit
// Register File, JAL(R) support.

module register_file_unit(clk, rst, Rs, Rd, Rt, busW, busA, busB,
                          RegDst, RegWrite, JumpAL_ID, PC_4, DestReg, 
                          JumpAL_WB, WriteReg);
    input wire          clk;
    input wire          rst;
    input wire [0:4]    Rs;
    input wire [0:4]    Rd;
    input wire [0:4]    Rt;
    input wire [0:31]   busW;
    input wire          RegDst;
    input wire          RegWrite;
    input wire          JumpAL_ID;
    input wire          JumpAL_WB;
    input wire  [0:29]  PC_4;
    input wire  [0:4]   WriteReg;
    output wire [0:31]  busA;
    output wire [0:31]  busB;
    output wire [0:4]   DestReg;

    wire [0:4]  dest_reg_0;
    wire [0:31] busW_in;

    wire [0:29] PC_8;
    wire [0:31] PC_8_32;

    // Destination Register Selection
    assign dest_reg_0 = (RegDst) ? Rt : Rd;
    assign DestReg = (JumpAL_ID) ? 5'd31 : dest_reg_0;

    // BusW Mux for JAL(R) Support
    simple_adder30 pc_calc(
        .A   (PC_4),
        .B   (30'h1),
        .sum (PC_8)
    );

    assign PC_8_32 = {PC_8, 2'b00};

    assign busW_in = (JumpAL_WB) ? PC_8_32 : busW;

    // Register File
    register_files reg_file_block(
        .clk    (clk),
        .rst    (rst),
        .RegWr  (RegWrite),
        .Rw     (WriteReg),
        .Data_in(busW_in),
        .Rs     (Rs),
        .BusA   (busA),
        .Rt     (Rt),
        .BusB   (busB)
    );

endmodule