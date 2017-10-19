

`ifndef FETCH_PIPELINE_REG
`define FETCH_PIPELINE_REG

`include "register/pipeline_reg.v"

module fetch_pipeline_reg(clock, clear, StallD, pc_plus_four_F, instruction_F, pc_plus_four_D, instruction_D);
	input wire clock;
	input wire clear;
	input wire [31:0] pc_plus_four_F;
	input wire [31:0] instruction_F;
    input wire StallD;
	output wire [31:0] pc_plus_four_D;
	output wire [31:0] instruction_D;
    	
	// This is to fix the fact that pc_src_d is stalled and won't change
	// in the middle of a stall.
	wire corrected_clear;

	assign corrected_clear = clear & !StallD;

	pipeline_reg_stall pc_plus_four(clock, corrected_clear, StallD, pc_plus_four_F, pc_plus_four_D);
	pipeline_reg_stall instruction(clock, corrected_clear, StallD, instruction_F, instruction_D);

endmodule

`endif


