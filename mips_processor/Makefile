
all: test
test: add.v control.v mem.v pc.v mux.v shifter.v test_bench.v alu.v mini_mux.v reg_mem.v sign_extend.v system.v
	iverilog test_bench.v add.v control.v mem.v pc.v mux.v shifter.v alu.v mini_mux.v reg_mem.v sign_extend.v system.v -o test
