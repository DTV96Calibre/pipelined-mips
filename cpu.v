
`ifndef CPU_V
`define CPU_V

`include "execute/execute_stage.v"
`include "decode/decode_stage.v"
`include "fetch/fetch.v"
`include "memory/mem_stage.v"
`include "register/fetch_pipeline_reg.v"
`include "register/writeback_pipeline_reg.v"
`include "hazard/hazard_unit.v"
module cpu(clock);

    input wire clock;
    
    // Inputs from control and decode
    wire [31:0] pc_branch_d;
    wire pc_src_d;

    // Input from hazard unit
    wire StallF;
    wire StallD;

    wire FlushE;
     
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    
    // Outputs to decode
    wire [31:0] pc_plus_4f;
    wire [31:0] pc_plus_4d;
    wire [31:0] instructionf;
    wire [31:0] instructiond;

    wire RegWriteD;
    wire MemtoRegD;
    wire MemWriteD;
    wire [3:0] ALUControlD;
    wire ALUSrcD;
    wire RegDstD;
    wire [31:0] RD1D;
    wire [31:0] RD2D;
    wire [4:0] RsD;
    wire [4:0] RtD;
    wire [4:0] RdD;
    wire [31:0] SignImmD;
    wire syscallD;
    wire [31:0] syscall_functD;
    wire [31:0] syscall_param1D;

    wire RegWriteE;
    wire MemtoRegE;
    wire MemWriteE;
    wire RegDstE;
    wire [3:0] ALUControlE;
    // ALU outputs (ignored)
    wire [31:0] RD1E;   // ALU outputs.
    wire [31:0] RD2E;
    wire [4:0] RsE;
    wire [4:0] RtE;
    wire [4:0] RdE;
    wire [31:0] SignImmE;
    wire [4:0] shamtE;
    wire [4:0] WriteRegE;
    wire [31:0] WriteDataE;
    wire [31:0] ALUOutE;

    // Inputs from the Fetch stage.
    wire [31:0] instruction;
    wire [31:0] pc_plus_four;

    // Outputs to EX
    wire [4:0] shamtD;

    // Outputs of the memory stage.
    wire RegWriteM;
    wire MemtoRegM;
    wire [31:0] Writeback_RD; 
    wire [31:0] ALUOutM;
    wire [4:0] WriteRegM;
    
    // Outputs of Writeback pipe
    wire RegWriteW;
    wire MemtoRegW;
    wire [31:0] ReadDataW;
    wire [31:0] ALUOutW;
    wire [4:0] WriteRegW;

    //this wire is a mux for ResultW
    wire [31:0] ResultW;
    assign ResultW = MemtoRegW ? ReadDataW : ALUOutW;

    // This is true if the current instruction is a jump / branch instruction.
    // This is distinct from pc_branch_d, which stores the pc to jump to.
    // This is distinct from pc_src_d, which decides whether the processor
    // actually jumps.
    wire BranchD;

    fetch fetch(
        .clk(clock),
        
        // Inputs from decode and control.
        .pc_branch_d(pc_branch_d),
        .pcsrc_d(pc_src_d),
        
        // Inputs from the hazard unit.
        .stallf(StallF),

        // Outputs to the decode stage.
        .pc_plus_4f(pc_plus_4f),
        .instructionf(instructionf)
        );
     fetch_pipeline_reg fpipe(
       .clock(clock)
     , .clear(1'b0)
     , .pc_plus_four_F(pc_plus_4f)
     , .instruction_F(instructionf)
     , .pc_plus_four_D(pc_plus_4d)
     , .instruction_D(instructiond));

    decode_stage decode(
        .clock(clock),
            
        // Inputs from fetch.
        .instruction(instructiond),
        .pc_plus_four(pc_plus_4d), 
    
        // Inputs from writeback.
        .writeback_value(ResultW), 
        .writeback_id(WriteRegW), 
        .reg_write_W(RegWriteW),

        // Decode to EX.
        .reg_rs_value(RD1D),
        .reg_rt_value(RD2D),
        .immediate(SignImmD),
        .reg_rs_id(RsD),
        .reg_rt_id(RtD),
        .reg_rd_id(RdD),
        .shamt(shamtD),

        // Control to EX
        .reg_write_D(RegWriteD),
        .mem_to_reg(MemtoRegD),
        .mem_write(MemWriteD),
        .alu_op(ALUControlD),
        .alu_src(ALUSrcD),
        .reg_dest(RegDstD),

        // Outputs back to fetch.
	.pc_src (pc_src_d),
        .jump_address(pc_branch_d),

	// Syscall logic
	.syscall(syscallD),
	.syscall_funct(syscall_functD),
	.syscall_param1(syscall_param1D)
        );

    execute_stage EX_stage(
        .clk(clock),
    
        // Input from the hazard control unit.
        .FlushE(FlushE),
    
        // Input from the decode stage.
        .RegWriteD(RegWriteD),
        .MemtoRegD(MemtoRegD),
        .MemWriteD(MemWriteD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RegDstD(RegDstD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .RsD(RsD),
        .RtD(RtD),
        .RdD(RdD),
        .SignImmD(SignImmD),
        .shamtD(shamtD),
	.syscallD(syscallD),
	.syscall_functD(syscall_functD),
	.syscall_param1D(syscall_param1D),

        // Output to the mem stage.
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .RegDstE(RegDstE),
        .ALUControlE(ALUControlE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .RsE(RsE),
        .RtE(RtE),
        .RdE(RdE),
        .SignImmE(SignImmE),
        .ResultW(ResultW),
        .ALUOutM(ALUOutM),

        // Input from the hazard unit.
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),

        // Wires from the control unit forwarded to the mem stage.
        .WriteRegE(WriteRegE),
        .WriteDataE(WriteDataE),
        .ALUOutE(ALUOutE)
        );

    mem_stage myMemStage(
        .CLK(clock),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .ALUOutE(ALUOutE),
        .WriteDataE(WriteDataE),
        .WriteRegE(WriteRegE),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .RD(Writeback_RD),
        .ALUOutM(ALUOutM),
        .WriteRegM(WriteRegM)
        );
    
    //writeback pipe
    writeback_pipeline_reg wpipe(
    .clock(clock), 
    .RegWriteM(RegWriteM),
    .MemtoRegM(MemtoRegM), 
    .ReadDataM(Writeback_RD), 
    .ALUOutM(ALUOutM), 
    .WriteRegM(WriteRegM), 
    .RegWriteW(RegWriteW), 
    .MemtoRegW(MemtoRegW), 
    .ReadDataW(ReadDataW), 
    .ALUOutW(ALUOutW), 
    .WriteRegW(WriteRegW));
    
    hazard_unit hazard(
	// Inputs
	.RsD(RsD),
	.RtD(RtD),
	.BranchD(pc_src_d),
	.RsE(RsE),
	.RtE(RtE),
	.WriteRegE(WriteRegE),
	.MemtoRegE(MemtoRegE),
	.RegWriteE(RegWriteE),
	.WriteRegM(WriteRegM),
	.MemtoRegM(MemtoRegM),
	.RegWriteM(RegWriteM),
	.WriteRegW(WriteRegW),
	.RegWriteW(RegWriteW),
	.syscallD(syscallD),

	// Outputs
	.StallF(StallF),
	.StallD(StallD),
	.FlushE(FlushE),
	.ForwardAE(ForwardAE),
	.ForwardBE(ForwardBE)
	);



endmodule

`endif
