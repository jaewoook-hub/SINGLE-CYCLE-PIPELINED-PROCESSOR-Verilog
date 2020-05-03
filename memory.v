// Instruction Memory
module imem(addr, instr);
    parameter       SIZE=8192;
    parameter       OFFSET=0;
    input [0:31]    addr;
    output [0:31]   instr;

    reg [0:7] 	    mem[0:(SIZE-1)];
    wire [0:31] 	phys_addr;

    assign phys_addr = addr - OFFSET;

    assign instr = {mem[phys_addr],mem[phys_addr+1],mem[phys_addr+2],mem[phys_addr+3]};

endmodule

// Data Memory
module dmem(addr, rData, wData, writeEnable, dsize, clk);
   parameter        SIZE=16384;
   input    [0:31]  addr, wData;
   input 	        writeEnable, clk;
   input    [0:1] 	dsize; // equivalent to bytes-1 ( 3=Word, 1=Halfword, 0=Byte)
   output   [0:31]  rData;

   reg [0:7] 	    mem[0:(SIZE-1)];

    // Write
    always @ (posedge clk) begin
        if (writeEnable) begin
            $display("writing to mem at %x val %x size %2d", addr, wData, dsize);

            case (dsize)
                2'b11: begin
                    // word
                    {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= wData[0:31];
                end
                2'b10: begin
                    // bad
                    $display("Invalid dsize: %x", dsize);
                end
                2'b01: begin
                    // halfword
                    {mem[addr], mem[addr+1]} <= wData[16:31];
                end
                2'b00: begin
                    // byte
                    mem[addr] <= wData[24:31];
                end
                default: $display("Invalid dsize: %x", dsize);
            endcase
        end
    end

    // Read
    assign rData = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};

endmodule