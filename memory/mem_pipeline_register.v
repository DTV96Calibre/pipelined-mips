`ifndef MIPS_H
`include "mips.h"
`endif

`include "register/pipeline_reg.v"

`ifndef MEM_PIPELINE_REGISTER
`define MEM_PIPELINE_REGISTER

// This module encapsulates the entire memory pipeline register.
module mem_pipeline_register(clk, RegWriteE, MemtoRegE, MemWriteE, ALUOutE, WriteDataE,
	WriteRegE, HasDivE, DivHiE, DivLoE, RegWriteM, MemtoRegM, MemWriteM, ALUOutM,
	WriteDataM, WriteRegM, HasDivM, DivHiM, DivLoM);

	// The clock.
	input wire clk;

	/*** The following inputs are fed from the Execute pipeline stage ***/

	// The control signal denoting whether a register is written to.
	input wire RegWriteE;

	// The control signal denoting whether data is being written from
	// memory to a register.
	input wire MemtoRegE;

	// The control signal denoting whether main memory is being written to.
	input wire MemWriteE;

	// The 32-bit output computed by the ALU.
	input wire [31:0] ALUOutE;

	// The 32-bit value to write to memory.
	input wire [31:0] WriteDataE;

	// The 5-bit register code that will be written to.
	input wire [4:0] WriteRegE;

	input wire HasDivE;
	input wire [31:0] DivHiE;
	input wire [31:0] DivLoE;

	/*** The following outputs are generated by the Memory pipeline stage ***/

	// The control signal denoting whether a register is written to.
	output RegWriteM;

	// The control signal denoting whether data is being written from
	// memory to a register.
	output MemtoRegM;

	// The control signal denoting whether main memory is being written to.
	output MemWriteM;

	// The 32-bit output computed by the ALU.
	output [31:0] ALUOutM;

	// The 32-bit value to write to memory.
	output [31:0] WriteDataM;

	// The 5-bit register code that will be written to.
	output [4:0] WriteRegM;

	output wire HasDivM;
	output wire [31:0] DivHiM;
	output wire [31:0] DivLoM;

	// Values in the mem stage will always pass through
	wire signal;
	assign signal = 0;

	// Propagate values
	pipeline_reg_1bit reg_write(clk, signal, RegWriteE, RegWriteM);
	pipeline_reg_1bit mem_to_reg(clk, signal, MemtoRegE, MemtoRegM);
	pipeline_reg_1bit mem_write(clk, signal, MemWriteE, MemWriteM);
	pipeline_reg_1bit HasDiv(clk, signal, HasDivE, HasDivM);
	pipeline_reg DivHi(clk, signal, DivHiE, DivHiM);
	pipeline_reg DivLo(clk, signal, DivLoE, DivLoM);
	pipeline_reg alu_out(clk, signal, ALUOutE, ALUOutM);
	pipeline_reg write_data(clk, signal, WriteDataE, WriteDataM);
	pipeline_reg_5bit write_reg(clk, signal, WriteRegE, WriteRegM);

endmodule
`endif
