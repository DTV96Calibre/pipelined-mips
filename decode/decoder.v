


`ifndef DECODER
`define DECODER

`include "decode/reg_file.v"
`include "decode/instr_splitter.v"
`include "decode/branch_adder.v"
`include "decode/jump_calculator.v"

// This module encapsulates the entire decode stage.
// 
// Note: The names of these input and output wires differ slightly from the
// names given in the pipelined mips diagram. The names and their
// corresponding wire names are listed at the bottom of this file.
//
// Note: To avoid race conditions, do not modify writeback_value,
// writeback_id, and should_writeback on negedge of the clock. This is because
// the register values are written at negedge of the clock.
//
// Note: the reg_rs_value and reg_rt_value wires live-update as is_i_type and
// instruction wires change. Additionally, these values may change if they
// correspond with the current writeback_id during a writeback. If a value
// must be sampled from these registers, do so at posedge of the clock, to
// allow the values to stabilize.
//
// TODO: Add reg_jump_address for jr instruction.
module decoder(clock, instruction, pc_plus_four, writeback_value,
		should_writeback, writeback_id, is_r_type, is_jr, reg_rs_value,
		reg_rt_value, immediate, branch_address, jump_address,
		reg_rs_id, reg_rt_id, reg_rd_id, shamt, funct, opcode);
	
	// The clock.
	input wire clock;
	
	// The current instruction.
	input wire [31:0] instruction;
	
	// The address of the next instruction to be executed (pc + 4).
	input wire [31:0] pc_plus_four;
	
	// This is the value to write into the register specified by
	// writeback_id, if should_writeback is 1. The writeback happens at
	// negedge of the clock, so don't change this value at negedge of the
	// clock to avoid data races.
	input wire [31:0] writeback_value;

	// This value is 1 if the writeback_value should be saved to the
	// register specified by writeback_id, 0 otherwise. The writeback
	// happens at negedge of the clock, so don't change this value at
	// negedge of the clock to avoid data races.
	input wire should_writeback;

	// This is the id of the register to write the writeback_value to if
	// should_writeback is 1. The writeback happens at negedge of the
	// clock, so don't change this value at negedge of the clock to avoid
	// data races.
	input wire [4:0] writeback_id;
	
	// This is 1 if the current instruction is R-type, 0 otherwise.
	input wire is_r_type;

	input wire is_jr;

	// This outputs the value of the RS register of the current instruction.
	// If the current instruction is J-type, consider this output junk.
	output wire [31:0] reg_rs_value;

	// This outputs the value of the RT register of the current instruction.
	// If the current instruction is not R-type, consider this output junk.
	output wire [31:0] reg_rt_value;
	
	// This outputs the sign-extended immediate value in the current
	// instruction. If the current instruction is not I-type, consider
	// this output junk.
	output wire [31:0] immediate;

	// This outputs the target address of a branch instruction, based on
	// pc + 4 and the immediate value in the instruction. If the current
	// instruction is not a branch, consider this output junk.
	output wire [31:0] branch_address;

	// This outputs the target address of an unconditional jump, based on
	// pc + 4 and the immediate value in the instruction. If the current
	// instruction is not J, consider this output junk.
	output wire [31:0] jump_address;

	// This outputs the ID of the RS register of the current instruction.
	// If the current instruction is J-type, consider this output junk.
	output wire [4:0] reg_rs_id;

	// This outputs the ID of the RT register of the current instruction.
	// If the current instruction is not R-type, consider this output
	// junk.
	output wire [4:0] reg_rt_id;

	// This outputs the ID of the RD register of the current instruction.
	// If the current instruction is J-type, consider this output junk.
	output wire [4:0] reg_rd_id;

	// This outputs the shift amount value of the current instruction. If
	// the current instruction is not sll or sra, consider this output
	// junk.
	output wire [4:0] shamt;

	// This outputs the function value of the current instruction. If the
	// current instruction is not R-type, consider this value junk.
	output wire [5:0] funct;

	output wire [5:0] opcode;
	
	// These are the register ID's decoded assuming the current instruction
	// is R-type.
	wire [4:0] r_type_rs;
	wire [4:0] r_type_rt;
	wire [4:0] r_type_rd;

	// These are the register ID's decoded assuming the current
	// instruction is I-type.
	wire [4:0] i_type_rs;
	wire [4:0] i_type_rd;

	// This is the unprocessed jump address immediate value in the current
	// instruction, assuming the current instruction is J-type.
	wire [25:0] raw_jump_address;

	// Decide which rs, rt, and rd ID values to output based on whether
	// the current instruction is I-type.
	assign reg_rs_id = is_r_type ? r_type_rs : i_type_rs;
	assign reg_rt_id = is_r_type ? r_type_rt : 0;
	assign reg_rd_id = is_r_type ? r_type_rd : i_type_rd;

	// This module contains the register file. Writeback happens at
	// negedge of the clock. It uses the ID values calculated based on
	// whether the current instruction is I-type.
	reg_file bank(
		.clock (clock),
		.reg_rs_id (reg_rs_id),
		.reg_rt_id (reg_rt_id),
		.control_reg_write (should_writeback),
		.control_write_id (writeback_id),
		.reg_write_value(writeback_value),
		.reg_rs_value(reg_rs_value),
		.reg_rt_value(reg_rt_value)
		);

	// This module extracts info from the current instruction, assuming it
	// is R-type.
	instr_splitter_r r_split(
		.instruction (instruction),
		.rs (r_type_rs),
		.rt (r_type_rt),
		.rd (r_type_rd),
		.shamt (shamt),
		.funct (funct)
		);

	// This module extracts info from the current instruction, assuming it
	// is I-type.
	instr_splitter_i i_split(
		.instruction (instruction),
		.rs (i_type_rs),
		.rd (i_type_rd),
		.immediate (immediate)
		);

	// This module extracts info from the current instruction, assuming it
	// is J-type.
	instr_splitter_j j_split(instruction, raw_jump_address);

	instr_opcode opcode_split(instruction, opcode);

	// This module calculates the actual target address, assuming the
	// current instruction is a branch instruction.
	branch_adder b_calc(immediate, pc_plus_four, branch_address);

	// This module calculates the actual target address, assuming the
	// current instruction is a jump instruction.
	wire [31:0] calc_jump_address;
	jump_calculator j_calc(raw_jump_address, pc_plus_four, calc_jump_address);
	
	assign jump_address = is_jr ? reg_rs_value : calc_jump_address;
	

endmodule
// The following table lists the names given on the pipelined mips diagram and
// their corresponding wire names.
//
// InstrD = instruction;
// RsD = reg_rs_id;
// RtD = reg_rt_id;
// RdD = reg_rd_id;
// SignImmD = immediate;
// PCPlus4D = pc_plus_four;
// PCBranchD = branch_address;
// RD1 = reg_rs_value;
// RD2 = reg_rt_value;
// ResultW = writeback_value;
// WriteRegW = should_writeback;


`endif





