`include "mips.h"
module test;
reg clk;

//pc variables
wire [31:0] nxtc;
wire [31:0] curc;
wire [31:0] p4;
reg [31:0] up;
wire [31:0] inst;
wire [31:0] jadd;

//system variables
wire [31:0] rv0;
wire [31:0] ra0;

//control variables
wire jump;
wire reg_dst;
wire branch;
wire mem_read;
wire mem_to_reg;
wire [3:0] alu_op;
wire reg_write;
wire alu_src;
wire mem_write;

//register memory variables
wire [4:0] wreg;
wire [31:0] wdata;
wire [31:0] rdata1;
wire [31:0] rdata2;

//alu variables
wire [31:0] idata;
wire [31:0] alu_result;
wire [31:0] rvalue;

//address variables
wire [31:0] mem_data;

//pc decleration
program_counter pc(clk, nxtc, curc);
adder ad1(curc, up, p4);
shifter_two shif2(inst, p4, jadd);
mux_two mux1(jadd, p4, jump, nxtc);

//instruction memory dec
memory mem(nxtc, inst);

//system decleration
system sys(inst, rv0, ra0);

//control decleration
control cntrl(inst, jump, reg_dst, branch, mem_read, mem_to_reg, alu_op, reg_write, alu_src, mem_write);

//register memory decleration
mini_mux mini(inst[`rd], inst[`rt], reg_dst, wreg);
reg_mem regs(inst[`rs], inst[`rt], wreg, wdata, reg_write, clk, rdata1, rdata2, rv0, ra0);

//alu decleration
mux_two mux_alu(idata, rdata2, alu_src, rvalue);
sign_extend sign_ex(inst[`immediate], idata);
alu alu1(rdata1, rvalue, alu_op, alu_result);

//address decleration
//to do
mux_two write_mux(mem_data, alu_result, mem_to_reg, wdata);

//clock
always
begin
    #10 clk = ~clk;
   /*if(inst == 0)
        $finish;
*/
end

//test code here
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
    clk = 0;
    up = 4;
    $monitor("curent address is %h, the current instruction is %h", curc, inst);
end
endmodule
