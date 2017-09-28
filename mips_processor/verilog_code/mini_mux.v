module mini_mux(first,second,flag,signal);
input [4:0] first;
input [4:0] second;
input flag;
output reg [4:0] signal;

always@(*)
begin
    if(flag == 1)
        signal = first;
    else
        signal = second;
    //$display("Wreg is %d", signal);
end
endmodule
