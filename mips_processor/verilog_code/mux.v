module mux_two(first,second,flag,signal);
input [31:0] first;
input [31:0] second;
input flag;
output reg [31:0] signal;

always@(*)
begin
    if(flag == 1)
        signal <= first;
    else
        signal <= second;
    //$display("mux flag: %d", flag);
end
endmodule
