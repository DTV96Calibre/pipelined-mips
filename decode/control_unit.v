

`ifndef CONTROL_UNIT
`define CONTROL_UNIT

`ifndef MIPS_H
`include "mips.h"
`endif

`include "decode/classify.v"
`include "decode/alu_control.v"

module control_unit(opcode, funct, instr_shamt, reg_rt_id, is_r_type, reg_write,
		mem_to_reg, mem_write, alu_op, alu_src, reg_dest,
		branch_variant, syscall, imm_is_unsigned, shamtD, is_mf_hi, is_mf_lo,
		HasDivD);

	input wire [5:0] opcode;
	input wire [5:0] funct;
	input wire [4:0] instr_shamt;
	
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

	// Outputs 0 if the current instruction uses an unsigned immediate
	// value; 1 otherwise.
	output wire imm_is_unsigned;
	
	output wire [4:0] shamtD;

	// 1 if the current instruction is MFHI, 0 otherwise.
	output wire is_mf_hi;

	// 1 if the current instruction is MFLO, 0 otherwise.
	output wire is_mf_lo;

	// 1 if the current instruction is divide.
	output wire HasDivD;

	// wire is_r_type;	// Declared as an output.
	wire is_i_type;
	wire is_j_type;
	
	wire is_shift_op;

	// True if the special opcode requires reg_write. Junk if the current
	// instruction isn't special.
	wire reg_write_special;

	alu_control alu(opcode, funct, alu_op);
	classify classifier(opcode, is_r_type, is_i_type, is_j_type);

	assign is_mf_hi = (opcode == `SPECIAL) && (funct == `MFHI);
	assign is_mf_lo = (opcode == `SPECIAL) && (funct == `MFLO);

	assign HasDivD = (opcode == `SPECIAL) && (funct == `DIV);

	assign mem_write =
		(opcode == `SW) |
		(opcode == `SB);
	
	assign reg_write =
		((opcode == `SPECIAL) && reg_write_special) |
		(opcode == `ADDIU) |
		(opcode == `ORI) |
		(opcode == `LUI);

	assign reg_write_special = !((funct == `JR) || (funct == `SYSCALL));
	
	assign imm_is_unsigned =
		(opcode == `ORI);

	assign mem_to_reg =
		(opcode == `LW);
	
	assign is_shift_op =
		(opcode == `SPECIAL) & (
		(funct == `SRA) |
		(funct == `SLL));
	
	// For LUI, the shamt needs to be set to 16.
	assign shamtD = (opcode == `LUI) ? 16 : instr_shamt;

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
			`SPECIAL: begin
				if (funct == `JR) begin
			       		branch_variant <= `BV_JUMP_REG;
				end else begin
					branch_variant <= `BV_NONE;
				end
			end
			`BEQ: branch_variant <= `BV_BEQ;
			`BNE: branch_variant <= `BV_BNE;
			default: branch_variant <= `BV_NONE;
		endcase
	end
	


endmodule


`endif




