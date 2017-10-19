

`ifndef CONTROL_UNIT
`define CONTROL_UNIT

`ifndef MIPS_H
`include "mips.h"
`endif

`include "decode/classify.v"
`include "decode/alu_control.v"

module control_unit(opcode, funct, reg_rt_id, is_r_type, reg_write,
		mem_to_reg, mem_write, alu_op, alu_src, reg_dest,
		branch_variant, syscall);

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

	output reg [2:0] branch_variant;
	
	// Outputs 1 if the current instruction is a syscall, 0 otherwise.
	output wire syscall;

	// wire is_r_type;	// Declared as an output.
	wire is_i_type;
	wire is_j_type;
	
	wire is_shift_op;

	alu_control alu(opcode, funct, alu_op);
	classify classifier(opcode, is_r_type, is_i_type, is_j_type);

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


	// This is 1 if and only if the instruction is an r-type instruction.
	assign reg_dest = is_r_type; 
	
	assign syscall = (opcode == `SPECIAL) & (funct == `SYSCALL);

	assign alu_src = is_i_type | is_shift_op;

	always @(*) begin
		case (opcode)
			`REGIMM: begin
			 	if (reg_rt_id == `BLTZ) begin
			 		branch_variant <= `BV_BLTZ;
				end else begin
					branch_variant <= `BV_NONE;
				end
			end
			`J: branch_variant <= `BV_JUMP;
			`JAL: branch_variant <= `BV_JUMP_LINK;
			`JR: branch_variant <= `BV_JUMP_REG;
			`BEQ: branch_variant <= `BV_BEQ;
			`BNE: branch_variant <= `BV_BNE;
			default: branch_variant <= `BV_NONE;
		endcase
	end
	


endmodule


`endif




