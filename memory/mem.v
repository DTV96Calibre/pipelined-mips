`ifndef MIPS_H
`include "mips.h"
`endif

`ifndef MEMORY
`define MEMORY

`define STACK_TOP 32'h7FFF_FFFC
`define STACK_BOT 32'h7FFF_FBFC

module Memory(input [31:0] A_in, WD, input WE, CLK, MemToRegM, output reg [31:0] RD);
	// Old: h'7fff_fffC
  reg [31:0] stack[`STACK_BOT:`STACK_TOP]; // 1k Stack from 7fff_fffc down
  reg [31:0] text[32'h00000000:32'h00000400]; // 1k text 00000000 up
  reg [31:0] data[32'h00000401:32'h00000801]; // 1k data starting from top of text going up
  initial begin
    //$readmemh("", mem);
  end

  wire [31:0] A;

  assign A = A_in;

  always @(*) begin
    if (A <= `STACK_TOP && A >= `STACK_BOT) begin
      RD <= stack[A];
    end else if (A <= 32'h00000400 && A >= 32'h00000000) begin
      RD <= text[A];
    end else if (A <= 32'h00000801 && A >= 32'h00000401) begin
      RD <= data[A];
    end else begin
      RD <= `undefined;
    end
  end

  always @(posedge CLK) begin
    if (WE) begin // MemWrite signal
      if (A <= 32'h7FFF_FFFC && A >= 32'h7FFF_FBFC) begin
        stack[A] <= WD;
      end else if (A <= 32'h00000400 && A >= 32'h00000000) begin
        text[A] <= WD;
      end else if (A <= 32'h00000801 && A >= 32'h00000401) begin
        data[A] <= WD;
      end else begin
        $display($time, ": Tried to write to unallocated address %h", A);
      end
    end // MemWrite signal if block
  end // always block
endmodule

`endif
// // Module representing everything between the register banks surrounding the Memory state
// module Memory(input RegWriteM, MemtoRegM, MemWriteM, input [31:0] ALUOutM, WriteDataM, input [4:0] WriteRegM,
//               output reg [31:0] RD, output reg MemtoRegM, RegWriteM);
//
// endmodule
