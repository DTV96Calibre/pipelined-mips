
`ifndef FETCH_V
`define FETCH_V

`include "fetch/mux.v"
`include "fetch/pc.v"
`include "util.v"
`include "fetch/mem.v"

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
`endif


