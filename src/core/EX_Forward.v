module EX_Forward(i_ID_EX_Rs,
                  i_ID_EX_Rt,
                  i_EX_MEM_Rd,
                  i_MEM_WB_Rd,
                  i_EX_MEM_reg_write,
                  i_MEM_WB_reg_write,
                  o_forward_A,
                  o_forward_B);

    input i_EX_MEM_reg_write;
    input i_MEM_WB_reg_write;
    input [5:0] i_ID_EX_Rs;
    input [5:0] i_ID_EX_Rt;
    input [5:0] i_EX_MEM_Rd;
    input [5:0] i_MEM_WB_Rd;
    
    output [1:0] o_forward_A;
    output [1:0] o_forward_B;
    
    wire [1:0] w_forward_A;
    wire [1:0] w_forward_B;
    
    wire w_cond1;
    assign w_cond1 = (i_EX_MEM_reg_write && !i_EX_MEM_Rd);
    
    wire w_cond2;
    assign w_cond2 = (i_MEM_WB_reg_write && !i_MEM_WB_Rd);
    
    // from EX_MEM Register: 01
    assign w_forward_A = (w_cond1 && (i_EX_MEM_Rd == i_ID_EX_Rs))?01:00;
    assign w_forward_B = (w_cond1 && (i_EX_MEM_Rd == i_ID_EX_Rt))?01:00;
    
    // from MEM_WB Register: 10
    assign o_forward_A = (w_cond2 && (i_MEM_WB_Rd == i_ID_EX_Rs)&&!w_forward_A)?10:w_forward_A;
    assign o_forward_B = (w_cond2 && (i_MEM_WB_Rd == i_ID_EX_Rt)&&!w_forward_B)?10:w_forward_B;
    
endmodule
