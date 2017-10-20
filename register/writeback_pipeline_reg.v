

`ifndef WRITE_PIPELINE_REG
`define WRITE_PIPELINE_REG

`include "register/pipeline_reg.v"

module writeback_pipeline_reg(clock, RegWriteM, MemtoRegM, ReadDataM, ALUOutM,
	       WriteRegM, HasDivM, DivHiM, DivLoM, RegWriteW, MemtoRegW, ReadDataW,
	       ALUOutW, WriteRegW, HasDivW, DivHiW, DivLoW);
	input wire clock;
    input wire RegWriteM; 
    input wire MemtoRegM; 
    input wire [31:0] ReadDataM; 
    input wire [31:0] ALUOutM; 
    input wire [4:0] WriteRegM; 
    input wire HasDivM;
    input wire [31:0] DivHiM;
    input wire [31:0] DivLoM;
    output wire RegWriteW; 
    output wire MemtoRegW; 
    output wire [31:0] ReadDataW; 
    output wire [31:0] ALUOutW; 
    output wire [4:0] WriteRegW;
    output wire HasDivW;
    output wire [31:0] DivHiW;
    output wire [31:0] DivLoW;

    wire clear;
    assign clear = 0;
	pipeline_reg_1bit RegWrite(clock, clear, RegWriteM, RegWriteW);
	pipeline_reg_1bit MemtoReg(clock, clear, MemtoRegM, MemtoRegW);
	pipeline_reg ReadData(clock, clear, ReadDataM, ReadDataW);
	pipeline_reg ALUOut(clock, clear, ALUOutM, ALUOutW);
	pipeline_reg_5bit WriteReg(clock, clear, WriteRegM, WriteRegW);
	pipeline_reg_1bit HasDiv(clock, clear, HasDivM, HasDivW);
	pipeline_reg DivHi(clock, clear, DivHiM, DivHiW);
	pipeline_reg DivLo(clock, clear, DivLoM, DivLoW);

endmodule

`endif


