


`ifndef MIPS_H
`include "mips.h"
`endif

`ifndef CLASSIFY
`define CLASSIFY

module classify(opcode, is_r_type, is_i_type, is_j_type);
	input wire [5:0] opcode;
	output wire is_r_type;
	output wire is_i_type;
	output wire is_j_type;
	
	// R-type: addu, div, mfhi, mflo, sll, sra, subu, jr, syscall, break
	// Instructions under "SPECIAL" opcode: addu, div, mfhi, mflo, sra,
	// sll, subu
	// pseudo-instructions: move a, b = addu a, $zero, b
	assign is_r_type = 
		(opcode == `SPECIAL);

	// I-type: addiu, lui, lw, sw, sb, b, bltz, bne, bnez
	// pseudo-instructions: 
	// 	li a, imm = 
	// 		lui a, upper_16(imm)
	// 		ori a, a, lower_16(imm)
	//	b label = beq $zero, $zero, label
	//	bnez $r, label = bne $zero, $r, label
	assign is_i_type = 
		(opcode == `ADDIU) |
		(opcode == `LUI) |
		(opcode == `LW) |
		(opcode == `SW) |
		(opcode == `SB) |
		(opcode == `REGIMM) |
		(opcode == `BNE) |
		(opcode == `BEQ) |
		(opcode == `ORI);

	// J-type: j, jal
	assign is_j_type = 
		(opcode == `J) |
		(opcode == `JAL);
endmodule


`endif


