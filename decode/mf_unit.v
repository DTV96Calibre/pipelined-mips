

`ifndef MF_UNIT_V
`define MF_UNIT_V



module mf_unit(reg_hi, reg_lo, instr_rs_value, is_mf_hi, is_mf_lo, actual_rs_value);
	
	input wire [31:0] reg_hi;
	input wire [31:0] reg_lo;
	input wire [31:0] instr_rs_value;
	input wire is_mf_hi;
	input wire is_mf_lo;
	output wire [31:0] actual_rs_value;

	wire [31:0] hilo_value;

	assign hilo_value = is_mf_hi ? reg_hi : reg_lo;

	assign actual_rs_value = (is_mf_hi | is_mf_lo) ? hilo_value : instr_rs_value;

endmodule




`endif





