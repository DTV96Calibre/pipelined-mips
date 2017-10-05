

`ifndef REG_ARRAY
`define REG_ARRAY

`include "register.v"

// This register array module instantiates an arbitrary-sized register array
// that accepts a signle should_write signal, ideal for use as a pipeline
// register.
//
// This module has a parameter, named SIZE, that specifies the number of
// registers to instantiate. The input_vals and output_vals vectors are
// [SIZE:0] elements each. To instantiate this module, use the following
// syntax:
//
// // This defines 31 registers.
// reg_array #(31) (clock, ...);
//
// Note: The size parameter follows the verilog convention of being one less
// than the actual count of registers. So if SIZE = 31, then there are 32
// actual registers, with indecies [31:0].
//
// Note: Avoid changing should_write and input_vals around posedge of the
// clock. See register.v for more information about race conditions.
module reg_array(clock, should_write, input_vals, output_vals);
	
	parameter SIZE = 0;

	input wire clock;

	input wire should_write;

	input wire [31:0] input_vals [SIZE:0];

	output wire [31:0] output_vals [SIZE:0];

	register [31:0] bank(clock, should_write, input_vals, output_vals);

endmodule


// This register array module instantiates an arbitrary-sized register array
// with the ability to write to particular registers. The input should_write
// is a vector [SIZE:0], which is connected to the corresponding register in
// the array.
//
// This module has a parameter, named SIZE, that specifies the number of
// registers to instantiate. The input_vals and output_vals vectors are
// [SIZE:0] elements each. To instantiate this module, use the following
// syntax:
//
// // This defines 31 registers.
// reg_array_with_write #(31) name(clock, ...);
//
// Note: The size parameter follows the verilog convention of being one less
// than the actual count of registers. So if SIZE = 31, then there are 32
// actual registers, with indecies [31:0].
//
// Note: Avoid changing should_write and input_vals at posedge of the clock.
// See register.v for more information on the possible race conditions.
module reg_array_with_write(clock, should_write, input_vals, output_vals);
	
	// This parameter specifies the number of registers to include in this
	// array.
	parameter SIZE;
	
	// The clock. This is passed on to the individual registers.
	input wire clock;
	
	// The should_write signal. Each individual register has its own 1 bit
	// should_write signal.
	input wire should_write [SIZE:0];
	
	// These are the input values used when should_write is set to 1 for
	// a particular register.
	input wire [31:0] input_vals [SIZE:0];
	
	// These are the corresponding output values of each register.
	output wire [31:0] output_vals [SIZE:0];
	
	register [SIZE:0] bank(clock, should_write, input_vals, output_vals);

endmodule


`endif

