`include "cpu.v"

/**
 * Tests the functionality of the entire pipelined MIPS CPU.
 */
module testbench();

reg clock;

initial begin
    $dumpfile("execute.dump");
    $dumpvars;

    clock = 0;
end

cpu myCPU(clock);

always @(*)
begin
    #1 clock = ~clock;
end

endmodule
