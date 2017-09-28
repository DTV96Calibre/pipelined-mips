/**
 * Takes two numbers and outputs their sum.
 * Inputs:  left -- 32-bit addend
 *          right -- 32-bit addend
 * Outputs: result -- 32-bit sum of left and right
 */
module adder(left, right, result);
input [31:0] left;
input [31:0] right;
output [31:0] result;

assign result = left + right;

endmodule
