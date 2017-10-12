
`ifndef ALU_OPS_H
`define ALU_OPS_H

`define ALU_OP_AND 3'b000
`define ALU_OP_OR 3'b001
`define ALU_OP_ADD 3'b010
`define ALU_OP_SUB 3'b011
`define ALU_OP_SRA 3'b110
`define ALU_OP_SLL 3'b111
`define ALU_OP_UNDEF 3'bxxx

// Include the mips header file, to ensure that there are defines to undef.
`ifndef MIPS_H
`include "mips.h"
`endif

// Undefine similarly-named defines from mips.h, to reduce the chance of typos.
`undef ALU_AND
`undef ALU_OR
`undef ALU_add
`undef ALU_sub
`undef ALU_slt
`undef ALU_NOR
`undef ALU_undef
`undef ALU_sll
`undef ALUOP_LWSW
`undef ALUOP_RFMT
`undef ALUOP_BR
`undef ALUOP_UNDEF

`endif
