
WARNS = -Wimplicit -Wportbind
VERSION = -g2005

register:
	iverilog register_test.v -o a.out -I../ $(WARNS) $(VERSION)
	./a.out


all: register

clean:
	rm a.out *.dump
	



