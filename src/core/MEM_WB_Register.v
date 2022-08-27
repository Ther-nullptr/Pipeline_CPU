`timescale 1ns / 1ps
module MEM_WB_Register(reset,
                       clk,
                       i_result,
                       i_mem_read_data,
                       i_pc_4,
                       i_imm_ext_out,
                       i_reg_write,
                       i_mem_to_reg,
                       i_mem_read,
                       i_write_register,
                       i_rt,
                       i_rd,
                       o_result,
                       o_mem_read_data,
                       o_pc_4,
                       o_imm_ext_out,
                       o_reg_write,
                       o_mem_to_reg,
                       o_mem_read,
                       o_write_register,
                       o_rt,
                       o_rd);
    input reset;
    input clk;
    input i_reg_write;
    input i_mem_read;
    input [1:0] i_mem_to_reg;
    input [4:0] i_write_register;
    input [4:0] i_rt;
    input [4:0] i_rd;
    input [31:0] i_result;
    input [31:0] i_mem_read_data;
    input [31:0] i_pc_4;
    input [31:0] i_imm_ext_out;
    
    output reg o_reg_write;
    output reg o_mem_read;
    output reg [1:0] o_mem_to_reg;
    output reg [4:0] o_write_register;
    output reg [4:0] o_rt;
    output reg [4:0] o_rd;
    output reg [31:0] o_result;
    output reg [31:0] o_mem_read_data;
    output reg [31:0] o_pc_4;
    output reg [31:0] o_imm_ext_out;
    
    always @(posedge clk) begin
            o_reg_write      <= i_reg_write;
            o_mem_read       <= i_mem_read;
            o_pc_4           <= i_pc_4;
            o_mem_to_reg     <= i_mem_to_reg;
            o_result         <= i_result;
            o_mem_read_data  <= i_mem_read_data;
            o_imm_ext_out    <= i_imm_ext_out;
            o_write_register <= i_write_register;
            o_rt             <= i_rt;
            o_rd             <= i_rd;
    end
    
endmodule
