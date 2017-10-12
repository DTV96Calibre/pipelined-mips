


`include "../reg_file.v"
`include "../register.v"

`define REG_ID_1 1
`define REG_ID_2 2

module reg_file_test();

	reg clock;
	reg should_write;
	reg [31:0] input_val;
	reg [4:0] input_reg_id;

	wire [31:0] output_1;
	wire [31:0] output_2;

	wire reference_reg_1_write;
	wire reference_reg_2_write;
	wire [31:0] reference_output_1;
	wire [31:0] reference_output_2;

	assign reference_reg_1_write = (input_reg_id == `REG_ID_1) && should_write;
	assign reference_reg_2_write = (input_reg_id == `REG_ID_2) && should_write;

	initial begin
		$dumpfile("reg_file_test.dump");
		$dumpvars;
		input_val = 5;
		should_write = 0;
		input_reg_id = `REG_ID_1;
		clock = 0;

		#1 clock = 1;
		#1 clock = 0;
		#1 clock = 1;
		#1 clock = 0;
		should_write = 1;
		#1 clock = 1;
		#1 clock = 0;
		#1 clock = 1;
		#1 clock = 0;
		// Test that output values only change on clock edges.
		input_val = 30;
		should_write = 0;
		#1 clock = 1;
		should_write = 1;
		#1 clock = 0;
		input_val = 29;
		input_reg_id = `REG_ID_2;
		#1 clock = 1;
		input_val = 4;
		#1 clock = 0;
		input_val = 10;
		input_reg_id = `REG_ID_1;;
		#1 clock = 1;
		should_write = 0;
		input_val = 7;
		#1 clock = 0;
		#1 clock = 1;
		#1 clock = 0;
		#1 clock = 1;

	end
	
	reg [4:0] id_1 = `REG_ID_1;
	reg [4:0] id_2 = `REG_ID_2;
	reg_file test(clock, id_1, id_2, should_write, input_reg_id,
			input_val, output_1, output_2);
	
	register ref1(clock, reference_reg_1_write, input_val, reference_output_1);
	register reg2(clock, reference_reg_2_write, input_val, reference_output_2);

	// Note: using @(*) tests to ensure that both register outputs are
	// synchronized with each other, using nonblocking assignments.
	always @(*) begin
		if (output_1 != reference_output_1) begin
			//$write($time, ": reg_file is behaving unexpectedly. See dumpfile.");
		end

		if (output_2 != reference_output_2) begin
			$write($time, ": reg_file is behaving unexpectedly. See dumpfile.");
		end
	end

endmodule





