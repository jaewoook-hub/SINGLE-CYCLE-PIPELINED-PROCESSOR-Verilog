module aa_test_bench();
    parameter IMEMFILE = "instr.hex";
    parameter DMEMFILE = "data.hex";
    reg [8*80-1:0]  filename;
    integer i;
    integer counter;

    reg clk, rst;
    wire [0:31] inst, dmem_dout, dmem_din;
    wire [0:31] pc, dmem_addr;
    wire [0:1]  byte_select;
    wire        MemWrite;

    pipeline_processor dut(
        .clk            (clk),
        .rst            (rst),
        .instruction    (inst),
        .dmem_dout      (dmem_dout),

        .pc             (pc),
        .MemWrite       (MemWrite),
        .dmem_addr      (dmem_addr),
        .byte_select    (byte_select),
        .dmem_din       (dmem_din)
    );

    dmem data_memory(
        .clk            (clk),
        .addr           (dmem_addr),
        .wData          (dmem_din),
        .writeEnable    (MemWrite),
        .dsize          (byte_select),
        .rData          (dmem_dout)
    );

    imem inst_memory(
        .addr           (pc),
        .instr          (inst)
    );

    initial begin
        // Clear Data Memory
        for (i = 0; i < data_memory.SIZE; i = i+1) begin
            data_memory.mem[i] = 8'h0;
        end

        // Load IMEM from file
        if (!$value$plusargs("instrfile=%s", filename)) begin
            filename = IMEMFILE;
        end
        $readmemh(filename, inst_memory.mem);

        // Load DMEM from file
        if (!$value$plusargs("datafile=%s", filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, data_memory.mem);
    end

    initial begin
        #0 counter = 0;
        #0  clk = 1;
        #0  rst = 0;
        #1  rst = 1;
    end

    always begin
        #5 clk = !clk; 
    end

    always@(posedge clk) begin
        counter = counter + 1;
        //$display("counter = %d", counter);
        if (counter == 50000) begin
            $writememh("datamem_out.txt", data_memory.mem, 8192, 8291);
            $dumpfile("waveform.vcd");
            $dumpvars(0, aa_test_bench);
        end
    end

endmodule