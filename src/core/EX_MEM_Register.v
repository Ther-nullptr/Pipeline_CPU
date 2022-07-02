`timescale 1ns / 1ps
module EX_MEM_Register(reset,
                       clk,
                       i_reg_write,
                       i_mem_to_reg,
                       i_mem_read,
                       i_mem_write,
                       i_pc_4,
                       i_data_2,
                       i_imm_ext,
                       i_write_register,
                       i_rt,
                       i_rd,
                       i_alu_result,
                       o_reg_write,
                       o_mem_to_reg,
                       o_mem_read,
                       o_mem_write,
                       o_pc_4,
                       o_data_2,
                       o_imm_ext,
                       o_write_register,
                       o_rt,
                       o_rd,
                       o_alu_result);
    
    input reset;
    input clk;
    input i_reg_write;
    input i_mem_read;
    input i_mem_write;
    
    input [1:0] i_mem_to_reg;
    input [4:0] i_write_register;
    input [4:0] i_rt;
    input [4:0] i_rd;
    input [31:0] i_pc_4;
    input [31:0] i_data_2;
    input [31:0] i_imm_ext;
    input [31:0] i_alu_result;
    
    output reg o_reg_write;
    output reg o_mem_read;
    output reg o_mem_write;
    output reg [1:0] o_mem_to_reg;
    output reg [4:0] o_write_register;
    output reg [4:0] o_rt;
    output reg [4:0] o_rd;
    output reg [31:0] o_pc_4;
    output reg [31:0] o_data_2;
    output reg [31:0] o_imm_ext;
    output reg [31:0] o_alu_result;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_reg_write      <= 0;
            o_mem_read       <= 0;
            o_mem_write      <= 0;
            o_pc_4           <= 0;
            o_data_2         <= 0;
            o_mem_to_reg     <= 0;
            o_write_register <= 0;
            o_rt             <= 0;
            o_rd             <= 0;
            o_imm_ext        <= 0;
        end
        else begin
            o_reg_write      <= i_reg_write;
            o_mem_write      <= i_mem_write;
            o_mem_read       <= i_mem_read;
            o_pc_4           <= i_pc_4;
            o_data_2         <= i_data_2;
            o_mem_to_reg     <= i_mem_to_reg;
            o_write_register <= i_write_register;
            o_rt             <= i_rt;
            o_rd             <= i_rd;
            o_imm_ext        <= i_imm_ext;
        end
    end
endmodule
