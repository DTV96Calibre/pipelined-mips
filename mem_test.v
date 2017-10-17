`ifndef MIPS_H
`include "mips.h"
`endif

`include "memory/mem.v"
`include "memory/mem_stage.v"
`include "memory/mem_pipeline_register.v"


module mem_test;
  reg clk, RegWriteE, MemtoRegE, MemWriteE = 0;
  reg [31:0] ALUOutE, WriteDataE = 0;
  reg [4:0] WriteRegE = 0;
  wire [31:0] ALUOutM, WriteDataM;
  wire [4:0] WriteRegM;
  mem_pipeline_register myMemPipeline(clk, RegWriteE, MemtoRegE, MemWriteE, ALUOutE, WriteDataE, WriteRegE,
    RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM);
  initial begin
    $monitor("clk", clk);
  end

  // Set address to within data range

endmodule
