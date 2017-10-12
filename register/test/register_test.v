
`include "../register.v"


module register_test();

	reg clock;

	reg [31:0] input_val;
	wire [31:0] output_val;
	reg should_write;

	initial begin
		$dumpfile("register_test.dump");
		$dumpvars(0, clock, input_val, output_val, should_write);
		
		clock = 0;
		input_val = 100;
		should_write = 0;
		#1 clock = 1;
		#1 clock = 0;
		input_val = 5;
		#1 clock = 1;
		#1 clock = 0;
		#1 clock = 1;
		#1 clock = 0;
		should_write = 1;
		#1 clock = 1;
		#1 clock = 0;
		#1 clock = 1;
		#1 clock = 0;
		input_val = 44;
		#1 clock = 1;
		#1 clock = 0;
		#1 clock = 1;
		#1 clock = 0;	
	end
	
	register test(clock, should_write, input_val, output_val);
		
	
endmodule













