module fetch_reg(instruction, pcplus4, pcplus4cur,instructioncur, StallD, PCSrcD, clk)
input [31:0] instruction;
input [31:0] pcplus4;
input StallD;
input PCSrcD;
input clk;
output instructioncur;
output RegWriteW;

always@(posedge clk)
begin
if(!StallD)
begin
pcplus4cur = pcplus4;
instructioncur = instruction;
end
end
endmodule
