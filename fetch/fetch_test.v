include "../mips.h"
module test;
wire [31:0] pc_plus_4f;
wire [31:0] instructionf;
reg clk;
always
begin
    #10 clk = ~clk;
end
fetch f(1, 1'b0, 1'b0, clk, pc_plus_4f, instructionf);
assign testr = instructionf;
//test code here
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
    clk = 0;
    $monitor("The current instruction is %h", instructionf);
end
endmodule*/

