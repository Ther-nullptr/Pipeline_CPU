`timescale 1ns / 1ps
module EX_Forward(i_ID_EX_Rs,
                  i_ID_EX_Rt,
                  i_write_register_MEM,
                  i_write_register_WB,
                  i_EX_MEM_reg_write,
                  i_MEM_WB_reg_write,
                  o_forward_A,
                  o_forward_B);

    input i_EX_MEM_reg_write;
    input i_MEM_WB_reg_write;
    input [4:0] i_ID_EX_Rs;
    input [4:0] i_ID_EX_Rt;
    input [4:0] i_write_register_MEM;
    input [4:0] i_write_register_WB;
    
    output [1:0] o_forward_A;
    output [1:0] o_forward_B;
    
    wire [1:0] w_forward_A;
    wire [1:0] w_forward_B;
    
    wire w_cond1;
    assign w_cond1 = (i_EX_MEM_reg_write && i_write_register_MEM);
    
    wire w_cond2;
    assign w_cond2 = (i_MEM_WB_reg_write && i_write_register_WB);
    
    // from EX_MEM Register: 01
    assign w_forward_A = (w_cond1 && (i_write_register_MEM == i_ID_EX_Rs))?2'b01:2'b00;
    assign w_forward_B = (w_cond1 && (i_write_register_MEM == i_ID_EX_Rt))?2'b01:2'b00;
    
    // from MEM_WB Register: 10
    assign o_forward_A = (w_cond2 && (i_write_register_WB == i_ID_EX_Rs)&&!w_forward_A)?2'b10:w_forward_A;
    assign o_forward_B = (w_cond2 && (i_write_register_WB == i_ID_EX_Rt)&&!w_forward_B)?2'b10:w_forward_B;
    
endmodule
