module shifter_two(ins_value, pc_four, out);
input [31:0] ins_value;
input [31:0] pc_four;
output reg [31:0] out;
always @(*)
begin
    out = pc_four[31:28] + (ins_value[25:0] << 2);
    //$display("shift %x, cur ins_value %x", out, ins_value);
end
    endmodule
