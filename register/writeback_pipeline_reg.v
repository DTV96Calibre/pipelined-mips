

`ifndef FETCH_PIPELINE_REG
`define FETCH_PIPELINE_REG

`include "register/pipeline_reg.v"

module writeback_pipeline_reg(clock, clear, RegWriteM, MemtoRegM, ReadDataM, ALUOutM, WriteRegM, RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW);
	input wire clock;
	input wire clear;
    input wire [31:0] RegWriteM; 
    input wire [31:0] MemtoRegM; 
    input wire [31:0] ReadDataM; 
    input wire [31:0] ALUOutM; 
    input wire [4:0] WriteRegM; 
    output wire [31:0] RegWriteW; 
    output wire [31:0] MemtoRegW; 
    output wire [31:0] ReadDataW; 
    output wire [31:0] ALUOutW; 
    output wire [4:0] WriteRegW;

	pipeline_reg RegWrite(clock, clear, RegWriteM, RegWriteW);
	pipeline_reg MemtoReg(clock, clear, MemtoRegM, MemtoRegW);
	pipeline_reg ReadData(clock, clear, ReadDataM, ReadDataW);
	pipeline_reg ALUOut(clock, clear, ALUOutM, ALUOutW);
	pipeline_reg_4bit RegWrite(clock, clear, WriteRegM, WriteRegW);

endmodule

`endif


