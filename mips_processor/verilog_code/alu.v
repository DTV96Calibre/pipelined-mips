module alu(lvalue, rvalue, aluOP, result);
input [31:0] lvalue;
input [31:0] rvalue;
input [3:0] aluOP;
output reg [31:0] result;
reg [31:0] truevall;
reg [31:0] truevalr;
always @(lvalue, rvalue)
begin
    if(lvalue == `dc32)
        truevall = 0;
    else
        truevall = lvalue;
    if(rvalue == `dc32)
        truevalr = 0;
    else
        truevalr = rvalue;
    case(aluOP)
        `ALU_add: result = truevall+truevalr;//lvalue + rvalue;
        `ALU_OR: result = truevall|truevalr;//lvalue | rvalue;
    endcase
end
endmodule

