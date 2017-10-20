/**
 * The arithmetic logic unit responsible for carrying out mathematical operations
 * of the MIPS instruction set.
 * Inputs:  lvalue -- 32-bit input
 *          rvalue -- 32-bit input
 *          aluOP -- 3-bit control signal identifying the operation
 * Outputs: result -- 32-bit result of the ALU's computation
 */
`ifndef MIPS_H
`include "mips.h"
`endif

`ifndef ALU
`define ALU
module alu(lvalue, rvalue, aluOP, shamt, result, div_hi, div_lo);

input [31:0] lvalue;
input [31:0] rvalue;
input [3:0] aluOP;
input [4:0] shamt;
output reg [31:0] result;
reg [31:0] truevall;
reg [31:0] truevalr;
output reg [31:0] div_lo;
output reg [31:0] div_hi;

always @(lvalue, rvalue, aluOP, shamt)
begin
    if (lvalue == `dc32)
        truevall = 0;
    else
        truevall = lvalue;
    if (rvalue == `dc32)
        truevalr = 0;
    else
        truevalr = rvalue;
    
    div_lo = 0;
    div_hi = 0;

    case (aluOP)
        `ALU_add: result = truevall + truevalr; // lvalue + rvalue;
        `ALU_sub: result = truevall - truevalr; // lvalue - rvalue;
        `ALU_OR:  result = truevall | truevalr; // lvalue | rvalue;
        `ALU_AND: result = truevall & truevalr; // lvalue & rvalue;
        `ALU_slt: result = truevall < truevalr; // lvalue < rvalue;
        `ALU_sll: result = truevall << shamt;
        `ALU_sra: result = truevall >>> shamt;
	`ALU_rs_pass: result = truevalr;	// truevaluer is the immediate value
	`ALU_slli: result = truevalr << shamt;	// SLL on an immediate value
	`ALU_div: begin
		div_lo = truevall / truevalr;
		div_hi = truevall % truevalr;
	end
        `ALU_undef: result = `dc32;
    endcase
end

endmodule
`endif
