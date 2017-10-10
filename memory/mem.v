`ifndef MIPS
`include "../mips.h"
`endif

`ifndef MEMORY
`define MEMORY

module Memory(input [31:0] A, WD, WE, input CLK, output reg [31:0] RD);
  reg [31:0] stack[32'h7FFBFC:32'h7FFFFC]; // 1k Stack from 7ffffffffffffffc down
  reg [31:0] text[32'h000000:32'h000400]; // 1k text 000000 up
  reg [31:0] data[32'h000401:32'h000801]; // 1k data starting from top of text going up
  initial begin
    //$readmemh("", mem);
  end
  // Read data on the negedge of CLK
  always @(negedge CLK) begin
    if (A <= 32'h7FFFFC && A >= 32'h7FFBFC) begin
      RD <= stack[A];
    end else if (A <= 32'h000400 && A >= 32'h000000) begin
      RD <= text[A];
    end else if (A <= 32'h000801 && A >= 32'h000401) begin
      RD <= data[A];
    end else begin
      RD <= `undefined;
      $display("Tried to read from unallocated address %h", A);
    end
  end
  // Write data on the posedge of CLK
  always @(posedge CLK) begin
    if (WE) begin // MemWrite signal
      if (A <= 32'h7FFFFC && A >= 32'h7FFBFC) begin
        stack[A] <= WD;
      end else if (A <= 32'h000400 && A >= 32'h000000) begin
        text[A] <= WD;
      end else if (A <= 32'h000801 && A >= 32'h000401) begin
        data[A] <= WD;
      end else begin
        $display("Tried to write to unallocated address %h", A);
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
