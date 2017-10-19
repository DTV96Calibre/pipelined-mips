

`ifndef MIPS_H
`include "mips.h"
`endif

`ifndef ALU_CONTROL
`define ALU_CONTROL


module alu_control(opcode, funct, alu_op);
	input wire [5:0] opcode;
	input wire [5:0] funct;
	output reg [3:0] alu_op;

	always @(*) begin
		case (opcode)
			`SPECIAL: begin 
				case (funct)
					`SYSCALL: alu_op = 0;
					`JR: alu_op = 0;
					`ADDU: alu_op = `ALU_add;
					`ADD: alu_op = `ALU_add;
					`SUBU: alu_op = `ALU_sub;
					`SRA: alu_op = `ALU_sra;
					`SLL: alu_op = `ALU_sll;
					default: alu_op = `ALU_undef;
				endcase
			end
			`SW: alu_op = `ALU_add;
			`SB: alu_op = `ALU_add;
			`LW: alu_op = `ALU_add;
			`ADDIU: alu_op = `ALU_add;
			`ORI: alu_op = `ALU_OR;
			`LUI: alu_op = `ALU_imm_nop;
			default: alu_op = `ALU_undef;
		endcase
	end
	

endmodule


`endif



