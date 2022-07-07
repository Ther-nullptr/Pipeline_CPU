`timescale 1ns / 1ps
module Hazard(reset,
              i_ID_EX_reg_write,
              i_ID_EX_mem_read,
              i_ID_EX_Rd,
              i_ID_EX_Rt,
              i_IF_ID_Rs,
              i_IF_ID_Rt,
              i_EX_MEM_mem_read,
              i_EX_MEM_Rd,
              i_branch,
              i_jump,
              o_IF_ID_flush,
              o_ID_EX_flush,
              o_IF_ID_keep,
              o_pc_keep);

    input reset;
    input i_ID_EX_mem_read;
    input i_ID_EX_reg_write;
    input i_EX_MEM_mem_read;
    input [1:0] i_jump;
    input [2:0] i_branch;
    input [4:0] i_ID_EX_Rd;
    input [4:0] i_ID_EX_Rt;
    input [4:0] i_IF_ID_Rs;
    input [4:0] i_IF_ID_Rt;
    input [4:0] i_EX_MEM_Rd;
    output o_IF_ID_flush;
    output o_ID_EX_flush;
    output o_IF_ID_keep;
    output o_pc_keep;
    
    // deal with 4 kinds of hazard
    // load use hazard: keep IF_ID_Register, keep PC, flush ID_EX_Register
    // beq hazard: flush IF_ID_Register, flush ID_EX_Register
    // jump hazard: flush IF_ID_Register
    // R/load-jr/jalr hazard: keep IF_ID_Register, keep PC, flush ID_EX_Register
    wire pc_keep1,pc_keep2,pc_keep3;
    
    // for load use hazard & R/load-jr/jalr
    assign pc_keep1    = (i_ID_EX_mem_read && ((i_ID_EX_Rt == i_IF_ID_Rs) || (i_ID_EX_Rt == i_IF_ID_Rt)));
    assign pc_keep2    = (i_jump == 2'b10 && (i_ID_EX_reg_write && ((i_ID_EX_Rd == i_IF_ID_Rs) || (i_ID_EX_Rd == i_IF_ID_Rt))));
    assign pc_keep3    = (i_jump == 2'b10 && (i_EX_MEM_mem_read && ((i_EX_MEM_Rd == i_IF_ID_Rs) || (i_EX_MEM_Rd == i_IF_ID_Rt))));
    assign o_pc_keep   = reset?0:(pc_keep1 || pc_keep2 || pc_keep3);
    assign o_IF_ID_keep = o_pc_keep;
    
    // for beq hazard
    assign o_ID_EX_flush = reset?0:i_branch;
    
    // for jump hazard
    assign o_IF_ID_flush = reset?0:(i_branch || i_jump);
    
    // for R/load-jr/jalr hazard
    
    
endmodule
