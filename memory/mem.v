module memory(readAddress, memInstruction);
input [31:0] readAddress;
output reg [31:0] memInstruction;

reg [31:0] mem [32'h100000:32'h101000];
initial begin
  $readmemh("mips_code/add_test.v"
  /*"jump.in"*/, mem);
end
reg [31:0] wordAddress;
always @(readAddress)
begin
  wordAddress = readAddress >> 2;
  memInstruction = mem[wordAddress];
  //$display("readAddress: %x", readAddress);
end
endmodule

module data_memory(input [31:0] address, write_data, input memwrite, memread, clk, output reg [31:0] read_data);
  reg [31:0] mem[0:255];
  always @(posedge clk) begin
    if (memwrite) begin
      mem[address] = write_data;
    end else;
  end
  always @(negedge clk) begin
    if (memread) begin
      read_data = mem[address];
    end
  end
endmodule

module dataMemory(input [31:0] A, WD, WE, output reg [31:0] RD);
  reg [31:0] stack[32'h7FFBFC:32'h7FFFFC]; // 1k Stack from 7ffffffffffffffc down
  reg [31:0] text[32'h000000:32'h000400]; // 1k text 000000 up
  reg [31:0] data[32'h000401:32'h000801]; // 1k data starting from top of text going up
  initial begin
    //$readmemh("", mem);
  end
endmodule

// // Module representing everything between the register banks surrounding the Memory state
// module Memory(input RegWriteM, MemtoRegM, MemWriteM, input [31:0] ALUOutM, WriteDataM, input [4:0] WriteRegM,
//               output reg [31:0] RD, output reg MemtoRegM, RegWriteM);
//
// endmodule
