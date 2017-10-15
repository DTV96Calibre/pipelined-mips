`include "../execute_stage.v"

/**
 * Tests the functionality of the execute stage of our pipelined processor.
 */
module ex_test();

reg clk;
reg FlushE;
reg RegWriteD;
reg MemtoRegD;
reg MemWriteD;
reg [3:0] ALUControlD;
reg ALUSrcD;
reg RegDstD;
reg [31:0] RD1;
reg [31:0] RD2;
reg [4:0] RsD;
reg [4:0] RtD;
reg [4:0] RdD;
reg [31:0] SignImmD;
reg [31:0] ResultW;
reg [31:0] ALUOutM;
reg [1:0] ForwardAE;
reg [1:0] ForwardBE;

wire RegWriteE;
wire MemtoRegE;
wire MemWriteE;
wire [3:0] ALUControlE;
wire ALUSrcE;
wire RegDstE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [4:0] RsE;
wire [4:0] RtE;
wire [4:0] RdE;
wire [31:0] SignImmE;
wire [4:0] WriteRegE;
wire [31:0] WriteDataE;
wire [31:0] ALUOutE;

initial begin
    // Init 'inputs'
    FlushE = 0;
    RegWriteD = 0;
    MemtoRegD = 0;
    MemWriteD = 0;
    ALUControlD = 4'b0010;
    ALUSrcD = 0;
    RegDstD = 0;
    RD1 = 32'b1;
    RD2 = 32'b11;
    RsD = 5'b00100;
    RtD = 5'b00101;
    RdD = 5'b00110;
    SignImmD = 32'b0;
    ResultW = 32'b111;
    ALUOutM = 32'b10;
    ForwardAE = 0;
    ForwardBE = 0;
    clk = 0;

    #1 clk = 1;
    #1 RegWriteD = 1;
    #1 RD1 = 32'b1110;
end

execute_stage EX_stage(clk, FlushE, RegWriteD, MemtoRegD, MemWriteD, ALUControlD,
    ALUSrcD, RegDstD, RD1, RD2, RsD, RtD, RdD, SignImmD,
    RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE,
    RD1E, RD2E, RsE, RtE, RdE, SignImmE,
    ResultW, ALUOutM, ForwardAE, ForwardBE, 
    WriteRegE, WriteDataE, ALUOutE);

always @(*)
begin
    $display("display ALUOutE: %h", ALUOutE);
end

endmodule

