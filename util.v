`ifndef MIPS_H
`include "mips.h"
`endif

`ifndef UTIL_H
`define UTIL_H
module adder (input [31:0] a, input [31:0] b, output [31:0] out);
  // always @(*) begin
  //   //$display("%m a:%h, b:%h, out:%h", a, b, out);
  // end
  assign out = a + b;
endmodule

module and1_2(input a, b, output reg out);
  always @(*) begin
    //$display("%m a:%b, b:%b, out:%b", a, b, out);
    out = a & b;
  end
endmodule

// Inverter outputs the inverse of the input if control is 1.
module inverter(input in, control, output reg out);
  always @(*) begin
    // $display("%m in:%b, out:%b, control:%b", in, out, control);
    out = (control) ? ~in : in;
  end
endmodule

module mux32_2 (input [31:0] a, b, input high_a, output [31:0] out);
  assign out = high_a ? a : b;
  // always @(high_a) begin
  //   $display("%m high_a=%d, out=%h", high_a, out);
  // end
endmodule

module mux5_2 (input [4:0] a, b, input high_a, output [4:0] out);
  assign out = high_a ? a : b;
  // always @(high_a) begin
  //   $display("%m high_a=%d, out=%h", high_a, out);
  // end
endmodule

// A = 0, B = 1, C = 2
module mux32_3 (input [31:0] a, b, c, input[1:0] control, output [31:0] out);
  assign out = (control == 0) ? a : (control == 1) ? b : (control == 2) ? c : `undefined;
endmodule


`endif
