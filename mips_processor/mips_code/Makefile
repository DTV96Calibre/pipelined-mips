# Makefile to generate bare metal code to run on a simulated (Verilog) processor
# from assembly code.
# Bucknell University
# Alan Marchiori 2014

AS=mipsel-linux-as
LD=mipsel-linux-ld
SREC=srec_cat

# these are the flags we need for bare metal code generation
CFLAGS=-mno-abicalls -fpic -nostdlib -static
LDFLAGS=-L/usr/remote/mipsel/lib/gcc/mipsel-buildroot-linux-uclibc/4.6.3 -lgcc

# change this line as needed
ASMSOURCE=add_test.s

SREC_OUTPUT=$(ASMSOURCE:.s=.srec)
VERILOG_OUTPUT=$(SREC_OUTPUT:.srec=.v)
OBJECTS=$(ASMSOURCE:.s=.o)

all: $(OBJECTS)
		# now link to a motorola SRecord
		$(LD) $(LDFLAGS) --oformat=srec $(OBJECTS) -o $(SREC_OUTPUT)
		# convert the SRecord file into a Verilog file
		$(SREC) $(SREC_OUTPUT) -Byte-swap 4 -o $(VERILOG_OUTPUT) -VMem

%.o: %.s
		# assemble to a motorola srecord file
		$(AS) $< -o $@

clean:
		@echo $(OBJECTS)
		rm -f $(OBJECTS) $(SREC_OUTPUT) $(VERILOG_OUTPUT)
