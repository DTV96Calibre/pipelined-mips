`ifndef MIPS_H
`include "mips.h"
`endif

`include "memory/mem.v"
`include "memory/mem_stage.v"
`include "memory/mem_pipeline_register.v"


module mem_test;
  reg clk=0, RegWriteE, MemtoRegE, MemWriteE = 0;
  reg [31:0] ALUOutE, WriteDataE = 0;
  reg [4:0] WriteRegE = 1;
  wire [31:0] ALUOutM, WriteDataM;
  wire [4:0] WriteRegM;
  // mem_pipeline_register myMemPipeline(clk, RegWriteE, MemtoRegE, MemWriteE, ALUOutE, WriteDataE, WriteRegE,
  //   RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM);
  wire RegWriteM, MemtoRegM;
  wire [31:0] RD;

  mem_stage myMemStage(clk, RegWriteE, MemtoRegE, MemWriteE,
    ALUOutE, WriteDataE, WriteRegE, RegWriteM, MemtoRegM, RD,
    ALUOutM, WriteRegM);
  initial begin
    $dumpfile("mem_test.vcd");
    $dumpvars(0, mem_test);

    // Test read/write to data
    MemWriteE = 1;
    ALUOutE = 32'h000401;
    WriteDataE = 32'h000001;
    #1 clk = 1; #1 clk = 0;
    #1 clk = 1; #1 clk = 0;
    MemWriteE = 0;
    #1 clk = 1; #1 clk = 0;
    #1 clk = 1; #1 clk = 0;
    if (RD == 32'h000001) begin
      $display("Success: Read written data from data segment");
    end else begin
      $display("Failure: Data Segment @%h: %h", ALUOutE, RD);
    end

    // Test read/write to stack
    MemWriteE = 1;
    ALUOutE = 32'h7FFBFC;
    WriteDataE = 32'h000001;
    #1 clk = 1; #1 clk = 0;
    MemWriteE = 0;
    #1 clk = 1; #1 clk = 0;
    #1 clk = 1; #1 clk = 0;
    if (RD == 32'h000001) begin
      $display("Success: Read written data from stack segment");
    end else begin
      $display("Failure: Stack Segment @%h: %h", ALUOutE, RD);
    end

    // Test read/write to text
    MemWriteE = 1;
    ALUOutE = 32'h000000;
    WriteDataE = 32'h000001;
    #1 clk = 1; #1 clk = 0;
    MemWriteE = 0;
    #1 clk = 1; #1 clk = 0;
    #1 clk = 1; #1 clk = 0;
    if (RD == 32'h000001) begin
      $display("Success: Read written data from text segment");
    end else begin
      $display("Failure: Text Segment @%h: %h", ALUOutE, RD);
    end

    // Test read/write to unallocated (shoud print 2 errors)
    ALUOutE = 32'h000402;
    MemtoRegE = 0;
    #1 clk = 1; #1 clk = 0;
    #1 clk = 1; #1 clk = 0;
    if (RD === `undefined) begin
      $display("Success: Read undefined from unallocated segment");
    end else begin
      $display("Failure: Unallocated Memory @%h: %h", ALUOutE, RD);
    end



  end

endmodule
