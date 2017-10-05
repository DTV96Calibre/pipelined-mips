module enable(prev,cur,flag,clk);
input [31:0] prev;
input flag;
input clk;
output [31:0] cur;

always@(posedge clk)
begin
if(flag)
    cur = prev;
else
    cur = 0;
end

endmodule
