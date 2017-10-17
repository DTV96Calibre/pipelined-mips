WARNS = -Wimplicit -Wportbind
VERSION = -g2005

execute_test:
	iverilog ex_test.v -o ex_test.out -I../ $(WARNS) $(VERSION)
	./ex_test.out

all: ex_test

clean:
	rm ex_test.out
