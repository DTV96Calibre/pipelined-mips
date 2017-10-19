


`ifndef DECODE_STAGE
`define DECODE_STAGE

`include "decode/decoder.v"
`include "decode/control_unit.v"
`include "decode/jump_unit.v"
`include "decode/syscall_unit.v"


module decode_stage(clock, instruction, pc_plus_four, writeback_value, writeback_id, reg_write_W,

		reg_rs_value, reg_rt_value, immediate, jump_address, reg_rs_id,
		reg_rt_id, reg_rd_id, shamt,

		reg_write_D, mem_to_reg, mem_write, alu_op, alu_src, reg_dest, jump);

	input wire clock;

	// Inputs from the Fetch stage.
	input wire [31:0] instruction;
	input wire [31:0] pc_plus_four;

	// Inputs from the Writeback stage.
	input wire [31:0] writeback_value;
	input wire [4:0] writeback_id;
	input wire reg_write_W;

	// Outputs from the decode stage.
	output wire [31:0] reg_rs_value;
	output wire [31:0] reg_rt_value;
	output wire [31:0] immediate;
	output wire [31:0] jump_address;
	output wire [4:0] reg_rs_id;
	output wire [4:0] reg_rt_id;
	output wire [4:0] reg_rd_id;
	output wire [4:0] shamt;

	// Outputs from the control unit.
	output wire reg_write_D;
	output wire mem_to_reg;
	output wire mem_write;
	output wire [3:0] alu_op;
	output wire alu_src;
	output wire reg_dest;
	output wire jump;
	
	// Internal wires.
	wire is_r_type;

	wire [5:0] funct;
	wire [5:0] opcode;


	wire [31:0] maybe_jump_address;
	wire [31:0] maybe_branch_address;
	
	wire control_jump;
	wire control_branch;
	wire control_jump_reg;
	wire control_jump_link;
	
	wire syscall;
	wire [31:0] syscall_funct;
	wire [31:0] syscall_param1;

	// The decoder
	// TODO: Link part of Jump and Link not implemented!
	decoder decoder(
		.clock (clock),
		.instruction (instruction),
		.pc_plus_four (pc_plus_four),
		.writeback_value (writeback_value),
		.should_writeback (reg_write_W),
		.writeback_id (writeback_id),
		.is_r_type (is_r_type),
		.is_jr (control_jump_reg),
		.reg_rs_value (reg_rs_value),
		.reg_rt_value (reg_rt_value),
		.immediate (immediate),
		.branch_address (maybe_branch_address),
		.jump_address (maybe_jump_address),
		.reg_rs_id (reg_rs_id),
		.reg_rt_id (reg_rt_id),
		.reg_rd_id (reg_rd_id),
		.shamt (shamt),
		.funct (funct),
		.opcode (opcode),
		.syscall_funct (syscall_funct),
		.syscall_param1 (syscall_param1)
		);

	// The control unit.
	control_unit control(
		.opcode (opcode),
		.funct (funct),
		.reg_rt_id (reg_rt_id),
		.is_r_type (is_r_type),
		.reg_write (reg_write_D),
		.mem_to_reg (mem_to_reg),
		.mem_write (mem_write),
		.alu_op (alu_op),
		.alu_src (alu_src),
		.reg_dest (reg_dest),
		.branch (control_branch),
		.jump (control_jump),
		.jump_reg (control_jump_reg),
		.jump_link (control_jump_link),
		.syscall (syscall)
		);
	
	// The jump decider.
	jump_unit jump_decider(
		.maybe_jump_address (maybe_jump_address),
		.maybe_branch_address (maybe_branch_address),
		.reg_rs (reg_rs_value),
		.control_branch (control_branch),
		.control_jump (control_jump),
		.control_jump_reg (control_jump_reg),
		.control_jump_link (control_jump_link),
		.jump_address (jump_address),
		.jump (jump)
		);
	
	syscall_unit syscall_unit(syscall, syscall_funct, syscall_param1);

endmodule


`endif




