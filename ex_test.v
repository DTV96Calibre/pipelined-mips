`include "execute/execute_stage.v"

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
reg [31:0] RD1D;
reg [31:0] RD2D;
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
wire RegDstE;
wire [3:0] ALUControlE;
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
    $dumpfile("execute.dump");
    $dumpvars;

    // Init 'inputs'
    FlushE = 0;
    RegWriteD = 0;
    MemtoRegD = 0;
    MemWriteD = 0;
    ALUControlD = 4'b0000;
    ALUSrcD = 0;
    RegDstD = 0;
    RD1D = 32'b11;
    RD2D = 32'b11;
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

    // Test 2-bit mux that outputs WriteRegE
    FlushE = 0;
    RtD = 12;
    RdD = 16;
    RegDstD = 0;
    #1 clk = 0;
    #1 clk = 1;
    RegDstD = 1;
    #1 clk = 0;
    #1 clk = 1;
    FlushE = 1;
    #1 clk = 0;
    #1 clk = 1;

    // Test 3-bit mux that outputs WriteDataE
    RD1D = 42;
    ResultW = 32;
    ALUOutM = 22;
    ForwardBE = 0;
    FlushE = 0;
    #1 clk = 0;
    #1 clk = 1;
    ForwardBE = 1;
    #1 clk = 0;
    #1 clk = 1;
    ForwardBE = 2;
    #1 clk = 0;
    #1 clk = 1;
    FlushE = 1;
    #1 clk = 0;
    #1 clk = 1;

    // Test ALU
    FlushE = 0;
    ALUControlD = 0; // AND
    ForwardAE = 0;
    ForwardBE = 0;
    ALUSrcD = 0;
    #1 clk = 0;
    #1 clk = 1;
    ForwardAE = 1;
    ALUControlD = 1; // OR
    #1 clk = 0;
    #1 clk = 1;
    ALUControlD = 2; // add
    ForwardAE = 0;
    ForwardBE = 1;
    #1 clk = 0;
    #1 clk = 1;
    ALUControlD = 6; // sub
    ForwardAE = 2;
    #1 clk = 0;
    #1 clk = 1;
    ALUControlD = 7; // slt
    ALUSrcD = 1;
    ForwardBE = 2;
    #1 clk = 0;
    #1 clk = 1;

end

execute_stage EX_stage(clk, FlushE, RegWriteD, MemtoRegD, MemWriteD, ALUControlD,
    ALUSrcD, RegDstD, RD1D, RD2D, RsD, RtD, RdD, SignImmD,
    RegWriteE, MemtoRegE, MemWriteE, RegDstE, ALUControlE,
    RD1E, RD2E, RsE, RtE, RdE, SignImmE,
    ResultW, ALUOutM, ForwardAE, ForwardBE, 
    WriteRegE, WriteDataE, ALUOutE);

always @(negedge clk) // Check for valid test cases after logic has finished propagating with rising clock edge
begin
    // Test 2-bit mux that outputs WriteRegE
    if (FlushE == 0 && RegDstD == 0)
    begin
        if (WriteRegE != RtE)
            $display("TEST FAILED: WriteRegE should be %b, was actually %b.", RtE, WriteRegE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && RegDstE == 1)
    begin
        if (WriteRegE != RdE)
            $display("TEST FAILED: WriteRegE should be %b, was actually %b.", RdE, WriteRegE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 1)
    begin
        if (WriteRegE != 0)
            $display("TEST FAILED: WriteRegE should be 0, was actually %b.", WriteRegE);
        else begin
            $display("Test passed");
        end
    end

    // Test 3-bit mux that outputs WriteDataE
    if (FlushE == 0 && ForwardBE == 0)
    begin
        if (WriteDataE != RD2E)
            $display("TEST FAILED: WriteDataE should be %b, was actually %b.", RD2E, WriteDataE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && ForwardBE == 1)
    begin
        if (WriteDataE != ResultW)
            $display("TEST FAILED: WriteDataE should be %b, was actually %b.", ResultW, WriteDataE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && ForwardBE == 2)
    begin
        if (WriteDataE != ALUOutM)
            $display("TEST FAILED: WriteDataE should be %b, was actually %b.", ALUOutM, WriteDataE);
        else begin
            $display("Test passed");
        end
    end

    // Test ALU
    if (FlushE == 0 && ForwardAE == 0 && ForwardBE == 0 && ALUControlE == 0)
    begin
        if (ALUOutE != (RD1E & RD2E))
            $display("TEST FAILED: ALUOutE should be %b, was actually %b.", (RD1D & RD2D), ALUOutE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && ForwardAE == 1 && ForwardBE == 0 && ALUControlE == 1)
    begin
        if (ALUOutE != (ResultW | RD2E))
            $display("TEST FAILED: ALUOutE should be %b, was actually %b.", (ResultW | RD2D), ALUOutE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && ForwardAE == 0 && ForwardBE == 1 && ALUControlE == 2)
    begin
        if (ALUOutE != (RD1E + ResultW))
            $display("TEST FAILED: ALUOutE should be %b, was actually %b.", (RD1E + ResultW), ALUOutE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && ForwardAE == 2 && ForwardBE == 1 && ALUControlE == 6)
    begin
        if (ALUOutE != (ALUOutM - ResultW))
            $display("TEST FAILED: ALUOutE should be %b, was actually %b.", (ALUOutM - ResultW), ALUOutE);
        else begin
            $display("Test passed");
        end
    end

    if (FlushE == 0 && ForwardAE == 2 && ForwardBE == 2 && ALUControlE == 7)
    begin
        if (ALUOutE != (ALUOutM < SignImmE))
            $display("TEST FAILED: ALUOutE should be %b, was actually %b.", (ALUOutM < SignImmE), ALUOutE);
        else begin
            $display("Test passed");
        end
    end
end

endmodule

