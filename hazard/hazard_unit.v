`ifndef MIPS_H
`include "mips.h"
`endif

`ifndef HAZARD_UNIT
`define HAZARD_UNIT

module hazard_unit(
	// Inputs
	RsD, RtD, BranchD, RsE, RtE, WriteRegE, MemtoRegE, RegWriteE, WriteRegM, 
	MemtoRegM, RegWriteM, WriteRegW, RegWriteW, syscallD,

	// Outputs
	StallF, StallD, FlushE, ForwardAE, ForwardBE
	);

/* Inputs */

// The first source register from the Decode stage.
input wire [4:0] RsD;

// The second source register from the Decode stage.
input wire [4:0] RtD;

// Whether a branch instruction is executing, as determined by the Decode stage.
input wire BranchD;

// The first source register from the Execute stage.
input wire [4:0] RsE;

// The second source register from the Execute stage.
input wire [4:0] RtE;

// The register that will be written to, as determined by the Execute stage.
input wire [4:0] WriteRegE;

// Whether data is being written from M->E, as determined by the Execute stage.
input wire MemtoRegE;

// Whether a register is written to, as determined by the Execute stage.
input wire RegWriteE;

// The register that will be written to, as determined by the Mem stage.
input wire [4:0] WriteRegM;

// Whether data is being written from M->E, as determined by the Mem stage.
input wire MemtoRegM;

// Whether a register is written to, as determined by the Mem stage.
input wire RegWriteM;

// The register that will be written to, as determined by the Writeback stage.
input wire [4:0] WriteRegW;

// Whether a register is written to, as determined by the Writeback stage.
input wire RegWriteW;

// Whether the decode stage is trying to do a syscall.
input wire syscallD;

/* Outputs */

// This flag is high when the Fetch stage needs to stall.
output wire StallF;

// This flag is high when the Decode stage needs to stall.
output wire StallD;

// True when forwarding a predicted branch to the Decode stage source reg Rs.
//output wire ForwardAD;

// True when forwarding a predicted branch to the Decode stage source reg Rt.
//output wire ForwardBD;

// True when the Execute stage needs to be flushed.
output wire FlushE;

// 1 for MEM/EX forwarding; 2 for EX/EX forwarding of Rs.
output wire [1:0] ForwardAE;

// 1 for MEM/EX forwarding; 2 for EX/EX forwarding of Rt.
output wire [1:0] ForwardBE;

// 1 if we need to stall for the syscall.
wire stallSyscall;

// Intermediate logic for stallSyscall.
wire stallSyscallV0;
wire stallSyscallA0;

// Branch stall when a branch is taken (so the next PC is still decoding)
wire branchStall;

// Additional stall while we wait for load word's WB stage
wire lwStall;

// Syscall needs to stall if there are any instructions in the pipeline write
// to v0 or a0.
assign stallSyscallV0 = (WriteRegE == `v0) || (WriteRegM == `v0) || (WriteRegW == `v0);
assign stallSyscallA0 = (WriteRegE == `a0) || (WriteRegM == `a0) || (WriteRegW == `a0);
assign stallSyscall = syscallD && (stallSyscallV0 || stallSyscallA0);

// branchStall is high if we're branching and currently writing to a source reg
assign branchStall = (BranchD && RegWriteE && 
					  (WriteRegE == RsD || WriteRegE == RtD))
				  || (BranchD && MemtoRegM && 
				  	  (WriteRegM == RsD || WriteRegM == RtD));

// lwStall is high when we're writing from memory to a reg
assign lwStall = ((RsD == RtE) || (RtD == RtE)) && MemtoRegE;
/*
initial begin
	StallF = 1;
	StallD = 1;
	ForwardAD = 0;
	ForwardBD = 0;
	FlushE = 0;
	ForwardAE = 0;
	ForwardBE = 0;
end
*/
// Execute to Decode forwarding (for branches)
//assign ForwardAD = (RsD != 0) && (RsD == WriteRegM) && RegWriteM;
//assign ForwardBD = (RtD != 0) && (RtD == WriteRegM) && RegWriteM;

// Stall when either stall signal has been set (inverted; see diagram)
assign StallF = !(branchStall || lwStall || stallSyscall);
assign StallD = !(branchStall || lwStall || stallSyscall);

// Flush when either stall signal has been set
assign FlushE = branchStall || lwStall || stallSyscall;

// Assign EX/EX or MEM/EX forwarding of Rs as appropriate
assign ForwardAE = ((RsE != 0) && (RsE == WriteRegM) && RegWriteM)  ? 2'b10 : // EX/EX
				   (((RsE != 0) && (RsE == WriteRegW) && RegWriteW) ? 2'b01 : // MEM/EX
				   0);

// Assign EX/EX or MEM/EX forwarding of Rt as appropriate
assign ForwardBE = ((RtE != 0) && (RtE == WriteRegM) && RegWriteM)  ? 2'b10 : // EX/EX
				   (((RtE != 0) && (RtE == WriteRegW) && RegWriteW) ? 2'b01 : // MEM/EX
				   0);

endmodule

`endif
