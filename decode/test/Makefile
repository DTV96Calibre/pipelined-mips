
WARNS = -Wimplicit -Wportbind
VERSION = -g2005

register:
	iverilog register_test.v -o a.out -I../ $(WARNS) $(VERSION)
	./a.out

reg_file:
	iverilog reg_file_test.v -o a.out -I../ $(WARNS) $(VERSION)
	./a.out

all: register reg_file

clean:
	rm a.out *.dump
	



