

`include "../../mips.h"


module test();
	reg [5:0] opcode;	
	reg [5:0] funct;

	wire reg_dest;
	wire jump;
	wire branch;
	wire mem_read;
	wire mem_to_reg;
	wire [2:0] alu_op;
	wire reg_write;
	wire alu_src;
	wire mem_write;
	
	wire [31:0] instruction;
	wire [10:0] control_summary;
	reg [10:0] solution;
	wire [10:0] difference;
	wire any_difference;

	assign instruction[31:26] = opcode;
	assign instruction[25:6] = 0;
	assign instruction[5:0] = funct;

	assign control_summary[10] = reg_dest;
	assign control_summary[9] = jump;
	assign control_summary[8] = branch;
	assign control_summary[7] = mem_read;
	assign control_summary[6] = mem_to_reg;
	assign control_summary[5:3] = alu_op;
	assign control_summary[2] = reg_write;
	assign control_summary[1] = alu_src;
	assign control_summary[0] = mem_write;

	assign difference = control_summary ^ solution;
	assign any_difference = difference == 0 ? 0 : 1;

	instruction_decoder decoder(
			.instruction (instruction),
			.reg_dest (reg_dest),
			.jump (jump),
			.branch (branch),
			.mem_read (mem_read),
			.mem_to_reg (mem_to_reg),
			.alu_op (alu_op),
			.reg_write (reg_write),
			.alu_src (alu_src),
			.mem_write (mem_write)
			);

	initial begin
		$dumpfile("opcode_test.dump");
		$dumpvars(0, opcode, funct, control_summary, solution, difference, any_difference);
		solution = 0;
		funct = `ADD;
		opcode = `SPECIAL;
		#1 funct = `SUB;
		#1 funct = `AND;
		#1 funct = `OR;
		#1 funct = `SLT;
		#1 opcode = `ADDI;
		#1 opcode = `ORI;
		#1 opcode = `LW;
		#1 opcode = `SW;
		#1 opcode = `BEQ;
		#1 opcode = `BNE;
		#1 opcode = `J;
		#1 opcode = `JR;
		#1 opcode = `JAL;
		#1 $finish();
	end

	always @(*) begin
		$display("opcode: %h", opcode);
		case (opcode)
			`SPECIAL : begin
				case (funct)
					`ADD : solution =  11'b00000010100;
					`SUB : solution =  11'b00000_110_100;
					`AND : solution =  11'b00000_000_100;
					`OR : solution =   11'b00000_001_100;
					`SLT : solution =  11'b00000_111_100;
					default : solution = 0;
				endcase
			end
			`ADDI : solution = 11'b10000_010_110;
			`ORI : solution =  11'b10000_001_110;
			`LW : solution =   11'b10011_010_110;
			`SW : solution =   11'b00000_010_011;
			`BEQ : solution =  11'b00100_110_000;
			`BNE : solution =  11'b00100_110_000;
			`J : solution =    11'b01000_000_000;
			default : solution = 0;
		endcase
	end
	
endmodule





