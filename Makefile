WARNS = -Wimplicit -Wportbind
VERSION = -g2005

all: everything_compile

execute_test:
	iverilog ex_test.v -o ex_test.out -I../ $(WARNS) $(VERSION)
	./ex_test.out

everything_compile:
	echo Note: This only compiles for syntax checking.
	iverilog everything.v -o everything.out $(WARNS) $(VERSION)

clean:
	rm ex_test.out
