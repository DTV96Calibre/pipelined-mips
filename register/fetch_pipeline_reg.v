

`ifndef FETCH_PIPELINE_REG
`define FETCH_PIPELINE_REG

`include "pipeline_reg.v"

module fetch_pipeline_reg(clock, clear, pc_plus_four_F, instruction_F, pc_plus_four_D, instruction_D);
	input wire clock;
	input wire clear;
	input wire [31:0] pc_plus_four_F;
	input wire [31:0] instruction_F;

	output wire [31:0] pc_plus_four_D;
	output wire [31:0] instruction_D;

	pipeline_reg pc_plus_four(clock, clear, pc_plus_four_F, pc_plus_four_D);
	pipeline_reg instruction(clock, clear, instruction_F, instruction_D);

endmodule

`endif


