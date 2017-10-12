
`ifndef REG_FILE
`define REG_FILE

`include "register.v"

// This module takes as input the clock, the registers to read, a control
// signal whether to write to a register, and the value to write to
// a register. The register bank performs writes on negedge of the clock. To
// avoid race conditions, try to avoid modifying control_reg_write,
// control_write_id, and reg_write_value at negedge of the clock.
//
// The current value of the registers is given by reg_rs_value and
// reg_rt_value. These values are updated continuously.
//
// In the event that a register being read is also being written, the read
// value may change. The read value will be stable before posedge of the
// clock. This should not matter; however, just in case, if code needs to sample
// the value discretely rather than continuously, it must wait until posedge of
// the clock.
module reg_file(clock, reg_rs_id, reg_rt_id, control_reg_write, control_write_id,
		reg_write_value, reg_rs_value, reg_rt_value);
	
	// The clock. This is inverted, then passed on to the individual
	// registers.
	input wire clock;
	
	// These wires control the registers that are output on the reg_rs_value
	// and reg_rt_value wires. The output values change immediately as
	// these values change.
	input wire [4:0] reg_rs_id;
	input wire [4:0] reg_rt_id;

	// This is 1 if the reg_write_value should be written to a register,
	// 0 otherwise.
	input wire control_reg_write;

	// This is the id of the register to write to at negedge of the clock,
	// if control_reg_write is set. To avoid race conditions, avoid
	// modifying this signal at negedge of the clock.
	input wire [4:0] control_write_id;

	// The value to be written to a register. To avoid race conditions,
	// avoid modifying this signal at negedge of the clock.
	input wire [31:0] reg_write_value;

	// This is the value of the rs and rt registers, respectively. These
	// values change immediately as the inputs reg_rs_id and reg_rt_id
	// change. See note at the top of the module if sampling from these
	// values, rather than using them continuously.
	output wire [31:0] reg_rs_value;
	output wire [31:0] reg_rt_value;
	
	// This is the inverse of the current clock. This is used to change
	// the register array's behavior from write-at-posedge to
	// write-at-negedge.
	wire inverted_clock;

	// These arrays are used to process the inputs and outputs of the 32
	// registers.
	wire reg_should_write [31:0];
	wire [31:0] bank_outputs [31:0];
	wire [31:0] reg_rs_outputs [31:0];
	wire [31:0] reg_rt_outputs [31:0];
	wire reg_is_perm [31:0];

	// Invert the clock for the registers.
	assign inverted_clock = ~clock;

	// This ensures no value is ever written to the $zero register.
	assign reg_is_perm[0] = 1;
	assign reg_is_perm[31:1] = 0;
	
	
	// For bank[i], the should_write value is reg_should_write[i] and the
	// curr_value is bank_outputs[i].
	register [31:0] bank(inverted_clock, reg_should_write, reg_write_value,
			bank_outputs);
	
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
			assign reg_rs_outputs[i] = (i == reg_rs_id) ? bank_outputs[i] : 0;
			assign reg_rt_outputs[i] = (i == reg_rt_id) ? bank_outputs[i] : 0;
		end
	endgenerate

	// Reg_one_outputs and reg_two_outputs will be an array of 0's except
	// for the registers that match. The reduction OR operator takes every
	// value in the array and or's them together, resulting in just the
	// value of the matching register.
	assign reg_rs_value = | reg_rs_outputs;
	assign reg_rt_value = | reg_rt_outputs;
endmodule

`endif
