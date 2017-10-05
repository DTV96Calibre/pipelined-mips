
`ifndef BRANCH_ADDER
`define BRANCH_ADDER

// This module takes in the immediate value in a branch instruction, and the
// next PC address (current PC address + 4), and outputs the target PC address
// to jump to.
module branch_adder(branch_immediate, pc_plus_four, jump_address);
	
	// The immediate value of the branch instruction, sign extended
	// appropriately.
	input wire [31:0] branch_immediate;
	
	// The next PC address (current PC address + 4).
	input wire [31:0] pc_plus_four;
	
	// The PC address to jump to.
	output wire [31:0] jump_address;
	
	// This is the branch_immediate, shifted to be word-aligned.
	wire [31:0] branch_offset;
	
	// The branch offset is word-aligned.
	assign branch_offset = branch_immediate << 2;
	
	// Simply add; if the branch offset is negative, two's compliment
	// ensures that the result is still correct.
	assign jump_address = pc_plus_four + branch_offset;

endmodule



`endif




