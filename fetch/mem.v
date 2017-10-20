
`ifndef FETCH_MEM_H
`define FETCH_MEM_H

module memory(readAddress, memInstruction);

input [31:0] readAddress; 
output [31:0] memInstruction;

reg [31:0] mem [32'h100000:32'h101000];

initial begin
  $readmemh("program.v", mem);
end

assign memInstruction = mem[readAddress >> 2];
endmodule

`endif
