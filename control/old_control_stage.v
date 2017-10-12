
`ifndef MIPS_H
`include "pips.h"
`endif

`ifndef INSTRUCTION_DECODER
`define INSTRUCTION_DECODER

// This module takes in the current instruction, and outputs the various signals
// needed to perform the opcode. All are flags, except for ALUOp, which is
// a 3-bit signal that is further decoded by the alu_decoder module.
module control_stage(opcode, funct, reg_write, mem_to_reg, mem_write, alu_control, alu_src, reg_dest, branch, jump, jump_reg);
	// The current instruction.
	input wire [31:0] instruction;
	
	// R-type opcodes store the destination register in [15:11], while
	// I-type opocdes store the destination register in [20:15].
	// The RegDest flag chooses which range to use; 0 corresponds to
	// R-type, 1 corresponds to I-type.
	output reg reg_dest;

	// The Jump flag is true when an unconditional jump is being
	// performed.
	output reg jump;

	// The Branch flag is true when a conditional jump is being performed.
	// The logic for whether to execute the jump is defered to the
	// jump_control module.
	output reg branch;
	
	// The MemRead flag is true when the memory unit should read data.
	output reg mem_read;
	
	// The MemToReg flag controls whether the output of the memory unit
	// or the output of the ALU should connect to the register writeback
	// datapath. 1 chooses memory unit, 0 chooses ALU.
       	output wire mem_to_reg;

	// The ALU opcode that is futher processed by the alu_decoder.
	output reg [2:0] alu_op;

	// The MemWrite flag is true when data should be written to memory.
	output reg mem_write;

	// The ALUSrc flag chooses whether a register or an immediate value
	// should be fed to the ALU. 1 corresponds to an immediate value,
	// 0 corresponds to a register.
	output reg alu_src;

	// The RegWrite flag is true when the result of memory or the ALU
	// should be written to a register.
	output reg reg_write;
	
	// The current opcode, extracted from the highest 6 bits of the
	// instruciton.
	wire [6:0] opcode;

	// The current funciton number, if applicable. This is used to
	// differentiate the various ALU-based ops.
	wire [5:0] function_number;

	// Outputs the translated ALU op based on the current function.
	// If the current opcode is not `SPECIAL, this is undefined.
	wire [2:0] function_to_alu_output;

	// Extract the opcode and funciton number from the current
	// instruciton.
	assign opcode = instruction[31:26];
	assign function_number = instruction[5:0];

	function_to_alu function_decoder(function_number, function_to_alu_output);

	// The MemToReg flag is equal in all cases to the value of the
	// mem_read flag; the only time we ever want memory to writeback to
	// a register is when we set the read flag to load data.
	assign mem_to_reg = mem_read;

	always @(*) begin
		// Clear all flags.
		reg_dest = 0;
		jump = 0;
		branch = 0;
		mem_read = 0;
		alu_op = 0;
		mem_write = 0;
		alu_src = 0;
		reg_write = 0;
		case (opcode)
			`SPECIAL : begin
				// This is an ALU op.
				alu_op = function_to_alu_output;

				// Check if the ALU decoder barfed.
				if (alu_op == `ALU_OP_UNKNOWN) begin
					$display("Unknown function %h", function_number);
				end else begin
					// We're writing to a register.
					reg_write = 1;
				end
			end
			`ADDI : begin
				// We're writing to a register.
				reg_write = 1;
				
				// This is an I-type instruction.
				reg_dest = 1;

				// We're adding.
				alu_op = `ALU_OP_ADD;

				// We're directing an immediate value to the
				// ALU.
				alu_src = 1;
			end
			`ORI : begin
				// We're writing to a register.
				reg_write = 1;

				// This is an I-type instruction.
				reg_dest = 1;

				// We're or-ing.
				alu_op = `ALU_OP_OR;

				// We're directing an immediate value to the
				// ALU.
				alu_src = 1;
			end
			`LW : begin
				// We're writing to a register.
				reg_write = 1;

				// This is an I-type instruction.
				reg_dest = 1;

				// We're adding.
				alu_op = `ALU_OP_ADD;

				// We're directing an immediate value to the
				// ALU.
				alu_src = 1;

				// We're reading from memory.
				mem_read = 1;
			end
			`SW : begin
				// We're adding.
				alu_op = `ALU_OP_ADD;

				// We're directing an immediate value to the
				// ALU.
				alu_src = 1;

				// We're writing to memory.
				mem_write = 1;
			end
			`BEQ : begin
				// We're subtracting.
				alu_op = `ALU_OP_SUB;

				// We're branching.
				branch = 1;
			end
			`BNE : begin
				// We're subtracting.
				alu_op = `ALU_OP_SUB;

				// We're branching.
				branch = 1;
			end
			//`JAL : // TODO: This is not shown on the provided datapath.
			//`JR : // TODO: This is not shown on the provided datapath.
			`J : jump = 1;
			default: $display("Unknown instruction %h", opcode);
		endcase

	end

	
	
endmodule

// This sub-module handles the logic for translating the function number into
// something the ALU decoder can understand.
module function_to_alu(function_number, alu_op);
	input wire [5:0] function_number;
	output reg [2:0] alu_op;

	always @(*) begin
		case (function_number)
			`ADD : alu_op <= `ALU_OP_ADD;
			`SUB : alu_op <= `ALU_OP_SUB;
			`AND : alu_op <= `ALU_OP_AND;
			`OR : alu_op <= `ALU_OP_OR;
			`SLT : alu_op <= `ALU_OP_SLT;
			// This special output code means an unknown
			// function_number was found.
			default: alu_op <= `ALU_OP_UNKNOWN;
		endcase
	end
endmodule

`endif
