`ifndef FETCH_MUX_V
`define FETCH_MUX_V

module mux_two(first,second,flag,signal);
input [31:0] first;
input [31:0] second;
input flag;
output [31:0] signal;
//copied from util
assign signal = flag ? first : second;
endmodule

`endif
