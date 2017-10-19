
`ifndef SYSCALL_UNIT_V
`define SYSCALL_UNIT_V


module syscall_unit(is_syscall, syscall_funct, syscall_param1);

	input wire is_syscall;

	input wire [31:0] syscall_funct;
	
	input wire [31:0] syscall_param1;


	always @(*) begin
		if (is_syscall) begin
			case (syscall_funct)
				`SYSCALL_PRINT_INT: $display("%d", syscall_param1);
				`SYSCALL_EXIT: $finish;
			endcase
		end
	end


endmodule



`endif







