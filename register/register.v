
`ifndef REGISTER
`define REGISTER

`define REG_START_VALUE 0

// This module implements a register.
// The value in new_value is saved to the register if should_write is 1
// at the posedge of the clock. To avoid race conditions, avoid modifying
// the should_write and new_value wires on the posedge of the clock.
module register(clock, should_write, new_value, curr_value);
	// The clock.
	input wire clock;
	
	// This wire enables whether the new_value should be saved at the next
	// clock posedge.
	input wire should_write;

	// New value for the register.
	input wire [31:0] new_value;

	// The current value stored in the register.
	output reg [31:0] curr_value;

	// This is just to avoid the race conditions inherent in the startup
	// of the simulation. Some simulators trigger clock edges at the
	// start, others don't.
	reg is_init;
	
	initial begin
		is_init = 0;
		curr_value = `REG_START_VALUE;
	end
	
	// Register accepts new value at posedge of every clock.
	always @(posedge clock) begin
		if (is_init) begin
			if (should_write) begin
				curr_value <= new_value;
			end
		end else begin
			is_init <= 1;
		end
	end

endmodule

`endif
