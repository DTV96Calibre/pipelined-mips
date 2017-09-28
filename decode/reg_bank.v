

`include "mips.h"

module reg_bank(clock, instruction, control_reg_write, control_reg_dest,
		reg_write_value, reg_one_value, reg_two_value);
	input wire clock;
	input wire [31:0] instruction;

	// This is 1 if the reg_write_value should be written to a register,
	// 0 otherwise.
	input wire control_reg_write;

	// This is 1 if the current instruction is I-type, 0 if R-type.
	input wire control_reg_dest;

	// The value to be written to a register.
	input wire [31:0] reg_write_value;

	// This is the value of the RS register.
	output wire [31:0] reg_one_value;

	// This is the value of the RT register, or junk if the instruction is
	// I-type.
	output wire [31:0] reg_two_value;

	// The three register ID's in the instruction.
	wire [4:0] reg_rs_id;
	wire [4:0] reg_rt_id;
	wire [4:0] reg_rd_id;
	
	// This is the register ID to write to.
	wire [4:0] reg_write_id;
	
	// These arrays are used to process the inputs and outputs of the 32
	// registers.
	wire reg_should_write [31:0];
	wire [31:0] bank_outputs [31:0];
	wire [31:0] reg_one_outputs [31:0];
	wire [31:0] reg_two_outputs [31:0];
	wire reg_is_perm [31:0];

	// This ensures no value is ever written to the $zero register.
	assign reg_is_perm[0] = 1;
	assign reg_is_perm[31:1] = 0;
	
	// Extract the three register ID's in the instruction.
	assign reg_rs_id = instruction[25:21];
	assign reg_rt_id = instruction[20:16];
	assign reg_rd_id = instruction[15:11];
	
	// Determine where to get the destination-register ID. 1 = I-type,
	// 0 = R-type.
	assign reg_write_id = control_reg_dest ? reg_rt_id : reg_rd_id;
	
	// This statement instantiates 31 register banks. The clock, 0, and
	// reg_write_value inputs are shared (identical) among all modules.
	// For bank[i], the should_write value is reg_should_write[i] and the
	// curr_value is bank_outputs[i].
	register bank[31:0] (clock, 0, reg_should_write, reg_write_value, bank_outputs);
	
	// The generate block allows us to use a for loop to set up wires for
	// each individual register.
	generate
		genvar i;
		// Loop through each register, generating stuff specific to
		// that register.
		for (i = 0; i < 32; i = i + 1) begin
			// Open this register for writing if reg_write_id
			// matches and it's NOT permanent.
			assign reg_should_write[i] = ((i == reg_write_id) ? 1 : 0) & ~reg_is_perm[i];
			// Move this register's value on to the corresponding output if
			// the reg_id matches.
			assign reg_one_outputs[i] = (i == reg_rs_id) ? bank_outputs[i] : 0;
			assign reg_two_outputs[i] = (i == reg_rt_id) ? bank_outputs[i] : 0;
		end
	endgenerate

	// Reg_one_outputs and reg_two_outputs will be an array of 0's except
	// for the registers that match. The reduction OR operator takes every
	// value in the array and or's them together, resulting in just the
	// value of the matching register.
	assign reg_one_value = | reg_one_outputs;
	assign reg_two_value = | reg_two_outputs;
endmodule


