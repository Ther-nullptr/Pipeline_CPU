module MEM_Forward(i_EX_MEM_Rt,
                   i_MEM_WB_Rt,
                   i_EX_MEM_mem_write,
                   i_MEM_WB_mem_read,
                   o_forward);
    input [5:0] i_EX_MEM_Rt;
    input [5:0] i_MEM_WB_Rt;
    input i_EX_MEM_mem_write;
    input i_MEM_WB_mem_read;
    output o_forward;
    
    assign o_forward = (!i_EX_MEM_Rt && i_EX_MEM_mem_write && i_MEM_WB_mem_read && i_EX_MEM_Rt == i_MEM_WB_Rt)?1:0;
    
endmodule
