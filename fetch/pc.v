module program_counter(clock, stallf, next_count, cur_count);
input [31:0] next_count;
input stallf;
input clock;
output reg [31:0] cur_count;
always @(posedge clock)
begin
    if(stallf==0)
        cur_count <= next_count;
end
initial
begin
    cur_count <= 32'h00400000;
end
endmodule
