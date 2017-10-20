`include "memory/mem_pipeline_register.v"
`include "memory/mem.v"

`ifndef MEM_STAGE
`define MEM_STAGE

/** Combines the pipeline register feeding the Memory stage with the memory
 * stage logic.
 */
module mem_stage(input CLK, RegWriteE, MemtoRegE, MemWriteE,
  input [31:0] ALUOutE, WriteDataE,
	input [4:0] WriteRegE, input HasDivE, input [31:0] DivHiE, input [31:0] DivLoE,
  output RegWriteM, MemtoRegM,
  output [31:0] RD, ALUOutM, output [4:0] WriteRegM, output HasDivM,
  output [31:0] DivHiM, output [31:0] DivLoM);

  // Internal wires
  wire MemWriteM;
  wire [31:0] WriteDataM;

  // Modules
  mem_pipeline_register memPipelineRegister(
    // inputs
    CLK, RegWriteE, MemtoRegE,
    MemWriteE, ALUOutE, WriteDataE, WriteRegE,
    HasDivE, DivHiE, DivLoE,
    // outputs
    RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM,
    HasDivM, DivHiM, DivLoM);

  Memory dataMemory(.A_in(ALUOutM), .WD(WriteDataM), .WE(MemWriteM), .CLK(CLK), .MemToRegM(MemtoRegM), .RD(RD));

endmodule

`endif
