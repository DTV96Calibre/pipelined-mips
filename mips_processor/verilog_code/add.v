module adder(left, right, result);
input [31:0] left;
input [31:0] right;
output [31:0] result;
assign result = left + right;

endmodule
