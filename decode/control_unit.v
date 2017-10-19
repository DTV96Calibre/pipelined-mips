

`ifndef CONTROL_UNIT
`define CONTROL_UNIT

`ifndef MIPS_H
`include "mips.h"
`endif

`include "decode/classify.v"
`include "decode/alu_control.v"

module control_unit(opcode, funct, reg_rt_id, is_r_type, reg_write, mem_to_reg, mem_write, alu_op, alu_src, reg_dest, branch, jump, jump_reg, jump_link);

	input wire [5:0] opcode;
	input wire [5:0] funct;
	
	// This register ID is used like a funct for opcode 0 (called REGIMM)
	input wire [4:0] reg_rt_id;

	// Used by the decoder.
	output wire is_r_type;

	output wire reg_write;
	output wire mem_to_reg;
	output wire mem_write;

	output wire [3:0] alu_op;
	
	output wire alu_src;
	output wire reg_dest;
	output wire branch;
	output wire jump;
	output wire jump_reg;
	output wire jump_link;

	// wire is_r_type;	// Declared as an output.
	wire is_i_type;
	wire is_j_type;
	
	wire is_shift_op;

	alu_control alu(opcode, funct, alu_op);
	classify classifier(opcode, is_r_type, is_i_type, is_j_type);

	assign branch =
		(opcode == `BNE) |
		(opcode == `BEQ) |
		((opcode == `REGIMM) & (reg_rt_id == `BLTZ));
	
	assign jump =
		(opcode == `J) |
		(opcode == `JAL) |
		(opcode == `JR);

	assign mem_write =
		(opcode == `SW) |
		(opcode == `SB);
	
	assign reg_write =
		(opcode == `SPECIAL) |
		(opcode == `ADDIU) |
		(opcode == `ORI) |
		(opcode == `SW) |
		(opcode == `SB) |
		(opcode == `LUI);
	
	assign mem_to_reg =
		(opcode == `LW);
	
	assign is_shift_op =
		(opcode == `SPECIAL) & (
		(funct == `SRA) |
		(funct == `SLL));

	// This is 1 if and only if the ALU needs an immediate value.
	assign alu_src = is_i_type | is_shift_op;

	// This is 1 if and only if the instruction is an r-type instruction.
	assign reg_dest = is_r_type; 
	
	assign jump_reg = (opcode == `JR);
	assign jump_link = (opcode == `JAL);

endmodule


`endif




