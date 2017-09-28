//will add more to this module as neccessary
module control(instruction, jump, reg_dst, branch, mem_read, mem_to_reg, alu_op, reg_write, alu_src, mem_write);
input [31:0] instruction;
output reg jump;
output reg reg_dst;
output reg branch;
output reg mem_read;
output reg mem_to_reg;
output reg [3:0] alu_op;
output reg reg_write;
output reg alu_src;
output reg mem_write;


reg zero;
reg one;


//Uses a large case statement to assign flags. There may be a more efficient way to do this, and will be updated if neccessary
always @(instruction)
begin
    case(instruction[`op])
    `ADDI:
    begin
        reg_dst = zero;
        jump = zero;
        branch = zero;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = `ALU_add;
        reg_write = one;
        alu_src = one;
        mem_write = zero;
    end
    `ADDIU:
    begin
        reg_dst = zero;
        jump = zero;
        branch = zero;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = `ALU_add;
        reg_write = one;
        alu_src = one;
        mem_write = zero;
    end

    `ORI:
    begin
        reg_dst = zero;
        jump = zero;
        branch = zero;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = `ALU_OR;
        reg_write = one;
        alu_src = one;
        mem_write = zero; 
    end
    `LW:
    begin
        reg_dst = zero;
        jump = zero;
        branch = zero;
        mem_read = one;
        mem_to_reg = one;
        alu_op = `ALU_add;
        reg_write = one;
        alu_src = one;
        mem_write = zero;  
    end
    `SW:
    begin
        reg_dst = zero;
        jump = zero;
        branch = zero;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = `ALU_add;
        reg_write = zero;
        alu_src = one;
        mem_write = one;
    end
    `BEQ:
    begin
        reg_dst = zero;
        jump = zero;
        branch = one;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = `ALU_sub;
        reg_write = zero;
        alu_src = zero;
        mem_write = zero; 
    end
    `BNE:
    begin
        reg_dst = zero;
        jump = zero;
        branch = one;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = `ALU_sub;
        reg_write = zero;
        alu_src = zero;
        mem_write = zero; 
    end
    `J:
    begin
        reg_dst = zero;
        jump = one;
        branch = zero;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = zero;
        reg_write = zero;
        alu_src = zero;
        mem_write = zero;
    end
    `SPECIAL:
    begin
        reg_dst = one;
        jump = zero;
        branch = one;
        mem_read = zero;
        mem_to_reg = zero;
        reg_write = one;
        alu_src = zero;
        mem_write = zero;
        case(instruction[`function])
        `ADD: alu_op = `ALU_add;
        `SUB: alu_op = `ALU_sub;
        `AND: alu_op = `ALU_AND;
        `OR: alu_op = `ALU_OR;
        `SLT: alu_op = `ALU_slt;
        default: 
        begin
            alu_op = zero;
            reg_write = zero;
            branch = zero;
        end
        endcase
    end
    default:
    begin
        reg_dst = zero;
        jump = zero;
        branch = zero;
        mem_read = zero;
        mem_to_reg = zero;
        alu_op = zero;
        reg_write = zero;
        alu_src = zero;
        mem_write = zero;
    end
endcase
end
initial
begin
    zero = 0;
    one = 1;
end
endmodule
