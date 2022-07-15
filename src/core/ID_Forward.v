module ID_Forward(
    i_IF_ID_Rs,
    i_IF_ID_Rt,
    i_write_register_MEM,
    i_write_register_WB,
    i_EX_MEM_reg_write,
    i_MEM_WB_reg_write,
    o_forward_A,
    o_forward_B
);

input [4:0] i_IF_ID_Rs;
input [4:0] i_IF_ID_Rt;
input [4:0] i_write_register_MEM;
input [4:0] i_write_register_WB;
input i_EX_MEM_reg_write,i_MEM_WB_reg_write;

output [1:0] o_forward_A;
output [1:0] o_forward_B;

assign o_forward_A = (i_EX_MEM_reg_write && (i_write_register_MEM == i_IF_ID_Rs))?2'b01:
                     (i_MEM_WB_reg_write && (i_write_register_WB == i_IF_ID_Rs))?2'b10:
                     2'b00;

assign o_forward_B = (i_EX_MEM_reg_write && (i_write_register_MEM == i_IF_ID_Rt))?2'b01:
                     (i_MEM_WB_reg_write && (i_write_register_WB == i_IF_ID_Rt))?2'b10:
                     2'b00;

endmodule