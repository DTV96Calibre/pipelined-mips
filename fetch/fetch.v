module fetch(pc_branch_d, pcsrc_d, stallf, clk, pc_plus_4f, instructionf);
input [31:0] pc_branch_d;
input pcsrc_d;
input stallf;
input clk;
output [31:0] pc_plus_4f;
output [31:0] instructionf;

wire [31:0] next_count;
wire [31:0] cur_count;
program_counter pc(clk, stallf, next_count, cur_count);
adder ad1(cur_count, 4, pc_plus_4f);
mux_two mux1(pc_branch_d, pc_plus_4f, pcsrc_d, next_count);

memory mem(cur_count, instructionf);

endmodule
//unit test
/*
`include "../mips.h"
module test;
wire [31:0] pc_plus_4f;
wire [31:0] instructionf;
reg clk;
always
begin
    #10 clk = ~clk;
end
fetch f(1, 1'b0, 1'b0, clk, pc_plus_4f, instructionf);
assign testr = instructionf;
//test code here
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
    clk = 0;
    $monitor("The current instruction is %h", instructionf);
end
endmodule*/
