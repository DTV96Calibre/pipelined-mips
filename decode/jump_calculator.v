
`ifndef JUMP_CALCULATOR
`define JUMP_CALCULATOR

// This module calculates the jump address given the next pc (current pc + 4)
// and the raw address encoded in the JMP instruction.
//
// TODO: Confirm this note is correct.
// Note: The jump address actually uses the top four bits of the CURRENT pc
// address, not pc + 4. This is accounted for in this module by subtracting
// 4 from the given pc + 4 value.
module jump_calculator(raw_address, pc_plus_four, jump_address);
	
	// The raw address from the jump instruction.
	input wire [25:0] raw_address;
	
	// The next pc address.
	input wire [31:0] pc_plus_four;
	
	// The actual target jump address.
	output wire [31:0] jump_address;

	// The actual current PC address.
	wire [31:0] current_pc;

	// Subtract four from the given PC address to get the original one.
	assign current_pc = pc_plus_four - 4;

	// The bottom two bits of the target jump address are always 0, to be
	// word-aligned.
	assign jump_address[1:0] = 0;
	
	// The top four bits of the target jump address are taken from the
	// current PC value.
	assign jump_address[31:28] = current_pc[31:28];

	// The rest of the bits are encoded in the jump instruction.
	assign jump_address[27:2] = raw_address;

endmodule


`endif






