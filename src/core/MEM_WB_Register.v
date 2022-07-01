`timescale 1ns / 1ps
module MEM_WB_Register(
    reset,
    clk,
    i_result,
    i_mem_read_data,
    i_pc_4,
    i_imm_ext_out,
    i_reg_write,
    i_mem_to_reg,
    o_result,
    o_mem_read_data,
    o_pc_4,
    o_imm_ext_out,
    o_reg_write,
    o_mem_to_reg
);
    input reset;
    input clk;    
    input i_reg_write;
    input [1:0] i_mem_to_reg;
    input [31:0] i_result;
    input [31:0] i_mem_read_data;
    input [31:0] i_pc_4;
    input [31:0] i_imm_ext_out;

    output reg o_reg_write;
    output reg [1:0] o_mem_to_reg;
    output reg [31:0] o_result;
    output reg [31:0] o_mem_read_data;
    output reg [31:0] o_pc_4;
    output reg [31:0] o_imm_ext_out;
    
endmodule