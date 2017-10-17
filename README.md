# pipelined-mips
A Verilog implementation of a pipelined MIPS processor

![alt text][cpu_diagram]

[cpu_diagram]: https://www.eg.bucknell.edu/~csci320/2016-fall/wp-content/uploads/2015/09/harris_pipeline_mips.png "Pipelined processor with full hazard handling"

Note: We do not own the above diagram and are only using it for reference when building our iVerilog implementation.

## Design
The processor roughly follows the Harris & Hennessy diagram shown above. Each pipeline stage is separated by pipeline registers which act as buffers between the stages.

In the actual iVerilog code, each stage is encapsulated within a module (e.g. *mem_state* encapsulates the Memory stage logic). This allows for easier high-level wiring and readability that closely reflects the design paradigm. Each stage's encapsulating module contains the register bank feeding that stage and all the logic associated with that stage.

### Fetch

### Decode

### Execute

### Memory
In this implementation, memory operations execute in a single cycle. Further, MemtoRegM is used
in Data Memory (Memory) to identify whether memory is being accessed intentionally or not. This is useful
as we aren't allocating the entire range of memory addresses for simulation performance reasons
and accessing unallocated addresses causes Data Memory to print an error. In the case that MemtoRegM
is 0, the RD (Read Data) output was going to be ignored anyway so no error is printed. RD is
set to \`undefined (32'hxxxxxxxx) in either case.

### Writeback


## Compilation
Each module file uses ifndef and define directives, allowing for developers to simply use the include
directive to include code from another file. This also means that compilation can be done at the
commandline while only referencing the primary testbench file.
Run "iverilog *testbenchname*.v -o *outputfilename*" while at the root of the project to compile
an executable called *outputfilename*. Due to pathing limitations with the include directive, in this
project, any top-level testbench file to be compiled is and must be located in the root directory.

## Execution

## Testing
