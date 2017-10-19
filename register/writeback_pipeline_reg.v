

`ifndef WRITE_PIPELINE_REG
`define WRITE_PIPELINE_REG

`include "register/pipeline_reg.v"

module writeback_pipeline_reg(clock, RegWriteM, MemtoRegM, ReadDataM, ALUOutM, WriteRegM, RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW);
	input wire clock;
    input wire RegWriteM; 
    input wire MemtoRegM; 
    input wire [31:0] ReadDataM; 
    input wire [31:0] ALUOutM; 
    input wire [4:0] WriteRegM; 
    output wire RegWriteW; 
    output wire MemtoRegW; 
    output wire [31:0] ReadDataW; 
    output wire [31:0] ALUOutW; 
    output wire [4:0] WriteRegW;

    wire clear;
    assign clear = 0;
	pipeline_reg_1bit RegWrite(clock, clear, RegWriteM, RegWriteW);
	pipeline_reg_1bit MemtoReg(clock, clear, MemtoRegM, MemtoRegW);
	pipeline_reg ReadData(clock, clear, ReadDataM, ReadDataW);
	pipeline_reg ALUOut(clock, clear, ALUOutM, ALUOutW);
	pipeline_reg_5bit WriteReg(clock, clear, WriteRegM, WriteRegW);

endmodule

`endif


