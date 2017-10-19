

`ifndef JUMP_UNIT
`define JUMP_UNIT

`include "mips.h"

// Takes in all the jump-related info from the control_unit and decoder
// modules, and decides whether to jump and where to jump.
module jump_unit(pc_plus_four, maybe_jump_address, maybe_branch_address,
		reg_rs, reg_rt, branch_variant, jump_address, pc_src, 
		branch, ra_write, ra_write_value);
	
	// The current PC, used for jump and link.
	input wire [31:0] pc_plus_four;

	// All the possible sources of the final jump address.
	input wire [31:0] maybe_jump_address;
	input wire [31:0] maybe_branch_address;
	
	// The current register values.
	input wire [31:0] reg_rs;
	input wire [31:0] reg_rt;

	// The specific kind of jump variant.
	input wire [2:0] branch_variant;
	
	// The actual jump address.
	output reg [31:0] jump_address;

	// Whether the PC should jump address. 1 = should jump.
	output reg pc_src;

	// Whether the current instruction is a branch/jump instruction.
	// 1 = branch/jump instruction, 0 = normal instruction.
	output wire branch;

	// This is 1 if ra_write_value should be stored to the ra register.
	output wire ra_write;

	// This is the value to write to the ra register, if needed.
	output wire [31:0] ra_write_value;

	initial
    begin
        pc_src = 0;
        jump_address = 0;
    end
	// This is the register containing the value to jump to if the
	// instruction is JUMP_REG.
	wire [31:0] jump_reg_address;

	assign jump_reg_address = reg_rs;

	assign branch = (branch_variant != `BV_NONE);
	
	assign ra_write = (branch_variant == `BV_JUMP_LINK);

	assign ra_write_value = pc_plus_four;
    
    // Determine pc_src.
	always @(*) begin
		case (branch_variant)
			`BV_NONE: pc_src <= 1'bx;
			
			`BV_JUMP: pc_src <= 1'b1;
			`BV_JUMP_REG: pc_src <= 1'b1;
			`BV_JUMP_LINK: pc_src <= 1'b1;
			
			`BV_BEQ: pc_src <= (reg_rs == reg_rt);
			`BV_BNE: pc_src <= (reg_rs != reg_rt);
			`BV_BLTZ: pc_src <= (reg_rs < 0);

			default: pc_src <= 1'bx;
		endcase
	end
	
	// Determine the end jump address.
	always @(*) begin
		case (branch_variant)
			`BV_NONE: jump_address <= 0;
			
			`BV_JUMP: jump_address <= maybe_jump_address;
			`BV_JUMP_LINK: jump_address <= maybe_jump_address;


			`BV_JUMP_REG: jump_address <= jump_reg_address;

			`BV_BEQ: jump_address <= maybe_branch_address;
			`BV_BNE: jump_address <= maybe_branch_address;
			`BV_BLTZ: jump_address <= maybe_branch_address;
		endcase
	end
	
	

endmodule


`endif




