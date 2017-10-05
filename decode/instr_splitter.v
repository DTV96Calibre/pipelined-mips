
`ifndef INSTR_SPLITTER
`define INSTR_SPLITTER

// This is a convenience module that extracts the opcode from a given
// instruction. It contains no state.
module instr_splitter_opcode(instruction, opcode);
	
	// The current instruction.
	input wire [31:0] instruction;
	
	// The current opcode.
	output wire [5:0] opcode;

	// Extract the opcode from the instruction. Bit numbers taken from the
	// mips green sheet.
	assign opcode = instruction[31:26];

endmodule

// This is a convenience module that extracts R-type instruction info. It
// contains no state. If the instruction is not R-type, then the output wires
// of this module should be treated as junk.
module instr_splitter_r(instruction, rs, rt, rd, shamt, funct);
	
	// The current instruction.
	input wire [31:0] instruction;

	// These are the current ID's for the RS, RT, and RD registers,
	// assuming the current instruction is R-type.
	output wire [4:0] rs;
	output wire [4:0] rt;
	output wire [4:0] rd;

	// This is the shift amount encoded in the current instruction,
	// assuming the current instruction is R-type. It is used
	// by the sll and sra instructions.
	output wire [4:0] shamt;

	// This is the current function code, assuming the current instruction
	// is R-type. It is used when the opcode is 0.
	output wire [5:0] funct;
	
	// Extract the various values in an R-type instruction. Bit numbers
	// taken from the mips green sheet.
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign shamt = instruction[10:6];
	assign funct = instruction[5:0];

endmodule

// This is a convenience module that extracts I-type instruction info. It
// contains no state. If the instruction is not I-type, then the output wires
// of this module should be treated as junk. The extracted immediate value is
// correctly sign extended.
module instr_splitter_i(instruction, rs, rd, immediate);
	
	// The current instruction.
	input wire [31:0] instruction;
	
	// The current ID's for the RS and RD registers, assuming the current
	// instruction is I-type.
	output wire [4:0] rs;
	output wire [4:0] rd;

	// The current immediate value, sign extended to 32 bits, assuming
	// the current instruction is I-type.
	output wire [31:0] immediate;
	
	// This wire stores the 16-bit immediate extracted from the
	// instruction.
	wire [15:0] raw_immediate;
	
	// Extract the rs, rd, and immediate values. Bit numbers are copied
	// from the mips green sheet.
	assign rs = instruction[25:21];
	assign rd = instruction[20:16];
	assign raw_immediate = instruction[15:0];
	
	// Sign-extend the extracted immediate value for later processing.
	imm_sign_extend extender(raw_immediate, immediate);

endmodule

// This is a convenience module that extracts J-type instruction info. It
// contains no state. If the instruction is not J-type, the output wires of
// this module should be treated as junk. The extracted address is not
// processed in any way.
module instr_splitter_j(instruction, imm_address);
	
	// The current instruction.
	input wire [31:0] instruction;
	
	// The current immediate address, assuming that the instruction is
	// J-type; junk otherwise.
	output wire [25:0] imm_address;
	
	// Extract the address. Bit numbers are copied from the mips green sheet.
	assign imm_address = instruction[25:0];

endmodule

// This is a helper module to sign-extend a 16-bit immediate into a 32-bit
// value. The sign extension is done via verilog's built-in sign extender.
module imm_sign_extend(raw_immediate, extended_immediate);
	
	// The 16-bit signed value extracted from an instruction.
	input signed wire [15:0] raw_immediate;

	// A 32-bit value that can be used for math and comparison.
	output signed wire [31:0] extended_immediate;

	// Verilog automatically sign extends the smaller, 16-bit value into
	// a 32-bit value.
	assign extended_immediate = raw_immediate;
endmodule


`endif
