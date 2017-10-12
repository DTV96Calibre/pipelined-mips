

`ifndef MIPS_H
`include "../mips.h"
`endif

`ifndef ALU_OPS_H
`include "../alu_ops.h"
`endif

`ifndef ALU_CONTROL
`define ALU_CONTROL


module alu_control(opcode, funct, alu_op);
	input wire [5:0] opcode;
	input wire [4:0] funct;
	output reg [2:0] alu_op;

	always @(*) begin
		case (opcode)
			`SPECIAL: begin 
				case (funct)
					`ADDU: alu_op = `ALU_OP_ADD;
					`SUBU: alu_op = `ALU_OP_SUB;
					`SRA: alu_op = `ALU_OP_SRA;
					`SLL: alu_op = `ALU_OP_SLL;
					default: alu_op = `ALU_OP_UNDEF;
				endcase
			end
			`SW: alu_op = `ALU_OP_ADD;
			`SB: alu_op = `ALU_OP_ADD;
			`LW: alu_op = `ALU_OP_ADD;
			`ADDIU: alu_op = `ALU_OP_OR;
			`ORI: alu_op = `ALU_OP_OR;
			default: alu_op = `ALU_OP_UNDEF;
		endcase
	end
	

endmodule


`endif



