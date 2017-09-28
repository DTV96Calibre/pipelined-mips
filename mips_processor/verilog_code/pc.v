module program_counter(clock, next_count, cur_count);
input [31:0] next_count;
input clock;
output reg [31:0] cur_count;

always @(posedge clock)
begin
    cur_count <= next_count;
    //$display("Current address: %x", cur_count);
end
initial
begin
    cur_count = 32'h00400000;
end

endmodule
