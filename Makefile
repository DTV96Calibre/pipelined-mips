WARNS = -Wimplicit -Wportbind
VERSION = -g2005

execute_test:
	iverilog ex_test.v -o ex_test.out -I../ $(WARNS) $(VERSION)
	./ex_test.out

everything_compile:
	echo Note: This only compiles for syntax checking.
	iverilog everything.v -o everything.out $(WARNS) $(VERSION)

all: everything_compile

clean:
	rm ex_test.out
