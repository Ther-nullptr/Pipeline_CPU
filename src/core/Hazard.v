`timescale 1ns / 1ps
module Hazard(
    i_ID_EX_mem_read,
    i_ID_EX_Rt,
    i_IF_ID_Rs,
    i_IF_ID_Rt,
    i_branch,
    i_jump,
    o_IF_ID_flush,
    o_ID_EX_flush,
    o_IF_ID_keep,
    o_pc_keep
);
    input i_ID_EX_mem_read;
    input i_jump;
    input [2:0] i_branch;
    input [4:0] i_ID_EX_Rt;
    input [4:0] i_IF_ID_Rs;
    input [4:0] i_IF_ID_Rt;
    output o_IF_ID_flush;
    output o_ID_EX_flush;
    output o_IF_ID_keep;
    output o_pc_keep;

    // deal with 3 kinds of hazard
    // load use hazard: keep IF_ID_Register, keep PC, flush ID_EX_Register  
    // beq hazard: flush IF_ID_Register, flush ID_EX_Register  
    // jump hazard: flush IF_ID_Register

    // for load use hazard
    assign o_pc_keep = (i_ID_EX_mem_read && ((i_ID_EX_Rt == i_IF_ID_Rs) || (i_ID_EX_Rt == i_IF_ID_Rt)));
    assign o_IF_ID_keep = o_pc_keep;

    // for beq hazard
    assign o_ID_EX_flush = i_branch;

    // for jump hazard
    assign o_IF_ID_flush = (i_branch || i_jump);

endmodule