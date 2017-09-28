module reg_mem(rreg1, rreg2, wreg, wdata, reg_write, clk, rdata1, rdata2, rv0, ra0);
input [4:0] rreg1;
input [4:0] rreg2;
input [4:0] wreg;
input [31:0] wdata;
input reg_write;
input clk;
output reg [31:0] rdata1;
output reg [31:0] rdata2;
//hacky way to do system calls
output reg [31:0] rv0;
output reg [31:0] ra0;
//register memory
reg [31:0] regs [31:0];
initial
begin
regs[`r0] = 0;
end

always @(negedge clk)
begin
    //$display("regs 0 is %x, rreg %b, rdata %x, reg at rreg %x", regs[0], rreg1, rdata1, regs[rreg1]);
    rdata1 = regs[rreg1];
    rdata2 = regs[rreg2];
    rv0 = regs[`v0];
    ra0 = regs[`a0];
    //$display("rdata1 %d from reg %b", rdata1, rreg1);
end

always @(posedge clk)
begin
    if(reg_write)
    begin
        regs[wreg] = wdata;
        //$display("%b register has %d data, the value should be %d", wreg, regs[wreg], regs[rreg1]); 
    end
    rv0 = regs[`v0];
    ra0 = regs[`a0];
end
endmodule
