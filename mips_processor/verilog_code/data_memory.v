/**
 * The segment responsible for reading from and writing to the data memory.
 * Inputs:  addr -- 32-bit address used to access memory
 *          wdata -- 32-bit data to write to memory
 *          mem_write -- 1-bit control signal that is high when memory needs to be written to
 * Outputs: rdata -- 32-bit data read from memory
 */
module data_memory(addr, wdata, mem_write, rdata);

input [31:0] addr;
input [31:0] wdata;
input mem_write;
output [31:0] rdata;

reg [31:0] dmem[32'h7ffffffc:32'h7fff0000];

// always @(*)
// begin
//     if (MemRead)
//     begin
//         readData = mem[address];
//     end

//     if (MemWrite)
//     begin
//         mem[address] = writeData;
//     end
// end

endmodule
