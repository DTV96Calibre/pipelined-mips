/**
 * The arithmetic logic unit responsible for carrying out mathematical operations
 * of the MIPS instruction set.
 * Inputs:  lvalue -- 32-bit input
 *          rvalue -- 32-bit input
 *          aluOP -- 3-bit control signal identifying the operation
 * Outputs: result -- 32-bit result of the ALU's computation
 */
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
        `ALU_add: result = truevall + truevalr; //lvalue + rvalue;
        `ALU_OR: result = truevall | truevalr; //lvalue | rvalue;
    endcase
end

endmodule
