
WARNS = -Wimplicit -Wportbind
VERSION = -g2005


reg_file:
	iverilog reg_file_test.v -o a.out -I../ $(WARNS) $(VERSION)
	./a.out

all: reg_file

clean:
	rm a.out *.dump
	



