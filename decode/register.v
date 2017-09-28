
`ifndef REGISTER
`define REGISTER


module register(clock, start_value, should_write, new_value, curr_value);
	input wire clock;
	input wire [31:0] start_value;
	input wire should_write;
	input wire [31:0] new_value;
	output reg [31:0] curr_value;
	reg is_init;

	initial begin
		is_init = 0;
		curr_value = start_value;
	end

	always @(negedge clock) begin
		if (is_init) begin
			if (should_write) begin
				curr_value <= new_value;
			end
		end else begin
			is_init <= 1;
		end
	end

endmodule

`endif
