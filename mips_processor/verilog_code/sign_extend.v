module sign_extend(inst, extend);
input [15:0] inst;
output reg [31:0] extend;
reg one;
reg zero;
initial
begin
    one = 1;
    zero = 0;
end
always @(*)
begin
    if(inst[15] == 0)
        extend = {{16{zero}}, inst};
    else
        extend = {{16{one}}, inst};
end
endmodule
