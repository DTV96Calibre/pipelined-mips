`include "memory/mem_pipeline_register.v"
`include "memory/mem.v"

`ifndef MEM_STAGE
`define MEM_STAGE

module mem_stage(input CLK, RegWriteE, MemtoRegE, MemWriteE,
  input [31:0] ALUOutE, WriteDataE,
	input [4:0] WriteRegE,
  output wire RegWriteM, wire MemtoRegM, RD, [31:0] ALUOutM, [4:0] WriteRegM);

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

  mem dataMemory(.A(ALUOutM), .WD(WriteDataM), .WE(MemWriteM), .CLK(CLK), .MemToRegM(MemToRegM), .RD(RD));

endmodule

`endif
