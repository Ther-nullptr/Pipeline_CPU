`timescale 1ns / 1ps
module MEM_Forward(i_EX_MEM_Rt,
                   i_MEM_WB_Rt,
                   i_EX_MEM_mem_write,
                   i_MEM_WB_mem_to_reg,
                   o_forward);
    input [4:0] i_EX_MEM_Rt;
    input [4:0] i_MEM_WB_Rt;
    input [1:0] i_MEM_WB_mem_to_reg;
    input i_EX_MEM_mem_write;
    output o_forward;
    
    assign o_forward = (i_EX_MEM_Rt && i_EX_MEM_mem_write && (i_MEM_WB_mem_to_reg == 2'b01 || i_MEM_WB_mem_to_reg == 2'b11) && i_EX_MEM_Rt == i_MEM_WB_Rt)?1:
                       (i_EX_MEM_Rt == 5'b11111 && i_EX_MEM_mem_write && i_MEM_WB_mem_to_reg == 2'b10)?1:0;
    
endmodule
