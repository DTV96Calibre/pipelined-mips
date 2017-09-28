//A module for handeling syscalls
//Lucas Nicolois Sep 9, 2017

module system(inst, rv0, a0);
input [31:0] inst;
input [31:0] rv0;
input [31:0] a0;

always@(inst)
begin
    if(inst == 8'h0c)
    begin
        case(rv0)
            1: $display("%d", a0);
            10: $finish;
        endcase
    end
end
endmodule
