


`ifndef DECODE_PIPELINE_REG
`define DECODE_PIPELINE_REG

`include "../register/pipeline_reg.v"

module decode_pipeline_reg(clock, clear,
		reg_rs_value_D, reg_rt_value_D, immediate_D,
		reg_rs_id_D, reg_rt_id_D, reg_rd_id_D, shamt_D, reg_write_D,
		mem_to_reg_D, mem_write_D, alu_op_D, alu_src_D, reg_dest_D,

		reg_rs_value_E, reg_rt_value_E, immediate_E,
		reg_rs_id_E, reg_rt_id_E, reg_rd_id_E, shamt_E, reg_write_E,
		mem_to_reg_E, mem_write_E, alu_op_E, alu_src_E, reg_dest_E);

	input wire clock;
	input wire clear;

	input wire [31:0] reg_rs_value_D;
	output wire [31:0] reg_rs_value_E;

	input wire [31:0] reg_rt_value_D;
	output wire [31:0] reg_rt_value_E;

	input wire [31:0] immediate_D;
	output wire [31:0] immediate_E;

	input wire [4:0] reg_rs_id_D;
	output wire [4:0] reg_rs_id_E;
	
	input wire [4:0] reg_rt_id_D;
	output wire [4:0] reg_rt_id_E;
	
	input wire [4:0] reg_rd_id_D;
	output wire [4:0] reg_rd_id_E;

	input wire [4:0] shamt_D;
	output wire [4:0] shamt_E;

	input wire reg_write_D;
	output wire reg_write_E;

	input wire mem_to_reg_D;
	output wire mem_to_reg_E;

	input wire mem_write_D;
	output wire mem_write_E;

	input wire [3:0] alu_op_D;
	output wire [3:0] alu_op_E;

	input wire alu_src_D;
	output wire alu_src_E;

	input wire reg_dest_D;
	output wire reg_dest_E;
	
	pipeline_reg reg_rs_value(clock, clear, reg_rs_value_D, reg_rs_value_E);
	pipeline_reg reg_rt_value(clock, clear, reg_rt_value_D, reg_rt_value_E);
	pipeline_reg immediate(clock, clear, immediate_D, immediate_E);
	pipeline_reg_5bit reg_rs_id(clock, clear, reg_rs_id_D, reg_rs_id_E);
	pipeline_reg_5bit reg_rt_id(clock, clear, reg_rt_id_D, reg_rt_id_E);
	pipeline_reg_5bit reg_rd_id(clock, clear, reg_rd_id_D, reg_rd_id_E);
	pipeline_reg_5bit shamt(clock, clear, shamt_D, shamt_E);
	pipeline_reg_1bit reg_write(clock, clear, reg_write_D, reg_write_E);
	pipeline_reg_1bit mem_to_reg(clock, clear, mem_to_reg_D, mem_to_reg_E);
	pipeline_reg_1bit mem_write(clock, clear, mem_write_D, mem_write_E);
	pipeline_reg_4bit alu_op(clock, clear, alu_op_D, alu_op_E);
	pipeline_reg_1bit alu_src(clock, clear, alu_src_D, alu_src_E);
	pipeline_reg_1bit reg_dest(clock, clear, reg_dest_D, reg_dest_E);


endmodule

`endif



