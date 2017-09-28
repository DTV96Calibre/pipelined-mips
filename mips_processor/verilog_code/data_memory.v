module data_memory(addr, wdata, mem_write, rdata);
input [31:0] addr;
input [31:0] wdata;
input mem_write;
output [31:0] rdata;

reg [31:0] dmem[32'h7ffffffc:32'h7fff0000];

initial

