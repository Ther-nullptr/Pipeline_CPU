module ID_Forward(
    i_IF_ID_Rs,
    i_IF_ID_Rt,
    i_EX_MEM_Rd,
    i_MEM_WB_Rd,
    i_EX_MEM_reg_write,
    i_MEM_WB_reg_write,
    o_forward_A,
    o_forward_B
);

input [4:0] i_IF_ID_Rs;
input [4:0] i_IF_ID_Rt;
input [4:0] i_EX_MEM_Rd;
input [4:0] i_MEM_WB_Rd;
input i_EX_MEM_reg_write,i_MEM_WB_reg_write;

output [1:0] o_forward_A;
output [1:0] o_forward_B;

assign o_forward_A = (i_EX_MEM_reg_write && (i_EX_MEM_Rd == i_IF_ID_Rs))?01:
                     (i_MEM_WB_reg_write && (i_MEM_WB_Rd == i_IF_ID_Rs))?10:
                     00;
                     
assign o_forward_B = (i_EX_MEM_reg_write && (i_EX_MEM_Rd == i_IF_ID_Rt))?01:
                     (i_MEM_WB_reg_write && (i_MEM_WB_Rd == i_IF_ID_Rt))?10:
                     00;

endmodule