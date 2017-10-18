

wire RegWriteM;
wire MemtoRegM;
wire [31:0] RD;
wire [31:0] ALUOutM;
wire [4:0] WriteRegM;

mem_stage myMemStage(.CLK(clock)
, .RegWriteE(RegWriteE)
, .MemtoRegE(MemtoRegE)
, .MemWriteE(MemWriteE)
, .ALUOutE(ALUOutE)
, .WriteDataE(WriteDataE)
, .WriteRegE(WriteRegE)
, .RegWriteM(RegWriteM)
, .MemtoRegM(MemtoRegM)
, .RD(RD)
, .ALUOutM(ALUOutM)
, .WriteRegM(WriteRegM));


