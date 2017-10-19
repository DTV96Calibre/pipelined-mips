# pipelined-mips
A Verilog implementation of a pipelined MIPS processor

![alt text][cpu_diagram]

[cpu_diagram]: https://www.eg.bucknell.edu/~csci320/2016-fall/wp-content/uploads/2015/09/harris_pipeline_mips.png "Pipelined processor with full hazard handling"

Note: We do not own the above diagram and are only using it for reference when building our iVerilog implementation.

## Design
The processor roughly follows the Harris & Hennessy diagram shown above. Each pipeline stage is separated by pipeline registers which act as buffers between the stages.

In the actual iVerilog code, each stage is encapsulated within a module (e.g. *mem_state* encapsulates the Memory stage logic). This allows for easier high-level wiring and readability that closely reflects the design paradigm. Each stage's encapsulating module contains the register bank feeding that stage and all the logic associated with that stage.

### Fetch

Fetch differs very little from the original diagram provided to us at the beginning of the project. The major differences exist in the new pc mux which is flipped due to iverilog setting the control signal to 1 initially thus causing an immediate jump. The second change is the placement of the enable bit which exists within the pc module. In addition the starting point of the pc is hard coded to avoid junk code produced by the mips compilers when necessary.

### Decode

### Execute

The execute stage is encapsulated in its own module, which instantiates, in addition to the execute
pipeline register, four multiplexers and the ALU module. Two muxes are 2-way (those that generate the
outgoing WriteRegE and SrcBE signals) and two are 3-way (those that generate the SrcAE and WriteDataE
signals). The inputs and outputs from the execute pipeline register are equivalent to those of the
diagram with the exception of the new 5-bit shamtD input and shamtE output, which feed into the ALU and
specifies the amount by which the source register Rs is shifted.

### Memory
In this implementation, memory operations execute in a single cycle. Further, MemtoRegM is used
in Data Memory (Memory) to identify whether memory is being accessed intentionally or not. This is useful
as we aren't allocating the entire range of memory addresses for simulation performance reasons
and accessing unallocated addresses causes Data Memory to print an error. In the case that MemtoRegM
is 0, the RD (Read Data) output was going to be ignored anyway so no error is printed. RD is
set to \`undefined (32'hxxxxxxxx) in either case.

In order to read information located in the text segment, a copy of text can be
accessed through the *Data Memory* module. This is required, for example, for printing strings
of characters defined in the text segment.

#### Note:
While text is considered read-only, this implementation expects the user to uphold
this standard and makes no attempt to prevent writing to the text segment of *Data Memory*.
This decision was made in order to avoid unnecessary complexity and to leave in
what could be considered a feature in having the ability to modify text. Because
instructions are fetched from a separate memory store, *Instruction Memory*,
modifying the text segment in *Data Memory* doesn't affect the instructions being fetched.


### Writeback
Writeback is primarily handled by the register module and writeback pipeline
register. Otherwise, it's a glorified mux and wire. Writeback was so insignificant
we forgot to implement it for quite a bit of time.


## Compilation
Each module file uses ifndef and define directives, allowing for developers to simply use the include
directive to include code from another file. This also means that compilation can be done at the
commandline while only referencing the primary testbench file.

Run "iverilog *testbenchname*.v -o *outputfilename*" while at the root of the project to compile
an executable called *outputfilename*. Due to pathing limitations with the include directive, in this
project, any top-level testbench file to be compiled is and must be located in the root directory.

## Execution
Using make runs the testbench. If you want to rerun the testbench, run ./testbench

## Testing
Compile the module level tests such as *mem_test.v* as described in **Compilation**. Each test reports success or failure while providing information
relevant to failures.

### mem_test.v
This test expects that the default preallocated memory is 1k each for data, text, and stack.
If this is changed, the expected error message associated with attempting to access
unallocated memory addresses may not be printed.

This test tests the entire mem_stage module. Signals are set so that data is written
to a valid address in each of the valid memory segments with a success or failure
status printed for each. The same is done for reading from those addresses. This
repeats for an invalid address outside of the allocated addresses.
An error for writing to unallocated space and for reading from unallocated space
while *MemToRegM* is 1 should print for successful tests. Another test
checks that if *MemToRegM* is 0, no error is printed.

More tests ensure that pass-through signals propagate correctly.

Compile *mem_test.v* as described in **Compilation** ("iverilog mem_test.v -o mem_test").
Execute the compiled test as described in **Execution** ("./mem_test").
