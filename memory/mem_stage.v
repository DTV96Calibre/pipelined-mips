`include "memory/mem_pipeline_register.v"
`include "memory/mem.v"

`ifndef MEM_STAGE
`define MEM_STAGE

/** Combines the pipeline register feeding the Memory stage with the memory
 * stage logic.
 */
module mem_stage(input CLK, RegWriteE, MemtoRegE, MemWriteE,
  input [31:0] ALUOutE, WriteDataE,
	input [4:0] WriteRegE,
  output RegWriteM, MemtoRegM,
  output [31:0] RD, ALUOutM, output [4:0] WriteRegM);

  // Internal wires
  wire MemWriteM;
  wire [31:0] WriteDataM;

  // Modules
  mem_pipeline_register memPipelineRegister(
    // inputs
    CLK, RegWriteE, MemtoRegE,
    MemWriteE, ALUOutE, WriteDataE, WriteRegE,
    // outputs
    RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM);

  Memory dataMemory(.A(ALUOutM), .WD(WriteDataM), .WE(MemWriteM), .CLK(CLK), .MemToRegM(MemtoRegM), .RD(RD));

endmodule

`endif
