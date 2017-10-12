


`ifndef PIPELINE_REG
`define PIPELINE_REG

`include "register.v"

module pipeline_reg(clock, clear, new_value, curr_value);
	input wire clock;
	input wire clear;
	input wire [31:0] new_value;
	output wire [31:0] curr_value;

	wire [31:0] gated_new_value;
	
	assign gated_new_value = clear ? 32'b0 : new_value;

	register r(clock, 1'b1, gated_new_value, curr_value);
	
endmodule


`endif



