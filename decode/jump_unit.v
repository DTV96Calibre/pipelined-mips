

`ifndef JUMP_UNIT
`define JUMP_UNIT


// Takes in all the jump-related info from the control_unit and decoder
// modules, and decides whether to jump and where to jump.
module jump_unit(maybe_jump_address, maybe_branch_address, reg_rs, control_branch,
	       control_jump, control_jump_reg, control_jump_link, jump_address, jump);
	
	// All the possible sources of the final jump address.
	input wire [31:0] maybe_jump_address;
	input wire [31:0] maybe_branch_address;
	input wire [31:0] reg_rs;

	// All the control unit outputs relating to jumping and branching.
	input wire control_jump;
	input wire control_branch;
	input wire control_jump_reg;
	input wire control_jump_link;
	
	// The actual jump address, and whether to jump.
	output wire [31:0] jump_address;
	output wire jump;
	
	assign jump = control_jump
		| control_branch
		| control_jump_reg
		| control_jump_link;
	
	// In C code:
	// if (jump) {
	// 	if (control_branch) {
	// 		// BEQ, BNE, etc...
	// 		return maybe_branch_address;
	// 	} else if (control_jump_reg) {
	// 		// JR
	// 		return reg_rs;
	// 	} else {
	// 		// J, JAL
	// 		return maybe_jump_address;
	// 	}
	// } else {
	// 	// There is no jump.
	// 	return 0;
	// }
	assign jump_address = jump ? 
		(control_branch ? maybe_branch_address : 
		(control_jump_reg ? reg_rs :
		 maybe_jump_address)) : 0;

endmodule


`endif




