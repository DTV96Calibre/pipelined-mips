
`ifndef REG_FILE
`define REG_FILE

`include "register/register.v"

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
		reg_write_value, reg_hi_W, reg_lo_W, HasDivW, reg_rs_value, reg_rt_value,
		ra_write, ra_write_value, syscall_funct, syscall_param1, reg_hi_D,
		reg_lo_D);
	
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

	input wire ra_write;
	input wire [31:0] ra_write_value;

	// This wire is true when the hi and lo registers should be updated
	// with the values in reg_hi_W and reg_lo_W.
	input wire HasDivW;

	input wire [31:0] reg_hi_W;
	input wire [31:0] reg_lo_W;

	// This is the value of the rs and rt registers, respectively. These
	// values change immediately as the inputs reg_rs_id and reg_rt_id
	// change. See note at the top of the module if sampling from these
	// values, rather than using them continuously.
	output reg [31:0] reg_rs_value;
	output reg [31:0] reg_rt_value;

	// These two register values are used for syscalls. Syscall function
	// is determined by $v0, and the first parameter is determined by $a0
	output wire [31:0] syscall_funct;
	output wire [31:0] syscall_param1;

	// The values of the special hi and lo registers. They're used in
	// divide and multiply instructions.
	output wire [31:0] reg_hi_D;
	output wire [31:0] reg_lo_D;
	
	// This is the inverse of the current clock. This is used to change
	// the register array's behavior from write-at-posedge to
	// write-at-negedge.
	wire inverted_clock;

	// These arrays are used to process the inputs and outputs of the 32
	// registers.
	wire reg_should_write [31:0];
	wire [31:0] bank_outputs [31:0];

	// Invert the clock for the registers.
	assign inverted_clock = ~clock;

	
	// For bank[i], the should_write value is reg_should_write[i] and the
	// curr_value is bank_outputs[i].
	//register bank [31:0] (inverted_clock, reg_should_write, reg_write_value,
	//		bank_outputs);
	
	// The generate block allows us to use a for loop to set up wires for
	// each individual register.
	generate
		genvar i;
		// Loop through each register, generating stuff specific to
		// that register.
		for (i = 0; i < 32; i = i + 1) begin
			wire reg_should_write_gen;
			wire reg_ra_should_write;
			wire [31:0] reg_output;
			wire is_ra_reg;
			wire [31:0] adj_reg_write_value;

			register r(inverted_clock, reg_should_write_gen | reg_ra_should_write, adj_reg_write_value, reg_output);
			
			// True if this is the ra register.
			assign is_ra_reg = (i == `ra);

			// True if this is the ra register AND it should
			// write.
			assign reg_ra_should_write = is_ra_reg && ra_write;

			// Open this register for writing if reg_write_id
			// matches and it's NOT permanent.
			assign reg_should_write_gen = ((i == control_write_id) ? 1 : 0) & (i != 0) & control_reg_write;
			
			assign adj_reg_write_value = reg_ra_should_write ? ra_write_value : reg_write_value;
			
			// Move this register's value on to the corresponding output if
			// the reg_id matches.
			assign bank_outputs[i] = reg_output;
		end
	endgenerate

	register hi(inverted_clock, HasDivW, reg_hi_W, reg_hi_D);
	register lo(inverted_clock, HasDivW, reg_lo_W, reg_lo_D);

	always@(*) begin
		reg_rs_value <= bank_outputs[reg_rs_id];
		reg_rt_value <= bank_outputs[reg_rt_id];
	end

	assign syscall_funct = bank_outputs[`v0];
	assign syscall_param1 = bank_outputs[`a0];

endmodule

`endif
