`timescale 1ns / 1ps
module ID_EX_Register(reset,
                      clk,
                      i_flush,
                      i_reg_write,
                      i_mem_to_reg,
                      i_mem_read,
                      i_mem_write,
                      i_reg_dst,
                      i_alu_op,
                      i_alu_src_a,
                      i_alu_src_b,
                      i_branch,
                      i_pc_4,
                      i_data_1,
                      i_data_2,
                      i_imm_ext,
                      i_imm_ext_shift,
                      i_rs,
                      i_rt,
                      i_rd,
                      i_shamt,
                      o_reg_write,
                      o_mem_to_reg,
                      o_mem_read,
                      o_mem_write,
                      o_reg_dst,
                      o_alu_op,
                      o_alu_src_a,
                      o_alu_src_b,
                      o_branch,
                      o_pc_4,
                      o_data_1,
                      o_data_2,
                      o_imm_ext,
                      o_imm_ext_shift,
                      o_rs,
                      o_rt,
                      o_rd,
                      o_shamt
                      );
    input reset;
    input clk;
    input i_flush;
    
    input i_reg_write;
    input i_mem_read;
    input i_mem_write;
    input i_alu_src_a;
    input i_alu_src_b;
    
    input [1:0] i_mem_to_reg;
    input [1:0] i_reg_dst;
    input [2:0] i_branch;
    input [3:0] i_alu_op;
    input [4:0] i_shamt;
    input [4:0] i_rs;
    input [4:0] i_rt;
    input [4:0] i_rd;
    input [5:0] i_funct;
    input [31:0] i_pc_4;
    input [31:0] i_data_1;
    input [31:0] i_data_2;
    input [31:0] i_imm_ext;
    input [31:0] i_imm_ext_shift;
    
    output reg o_reg_write;
    output reg o_mem_read;
    output reg o_mem_write;
    output reg o_alu_src_a;
    output reg o_alu_src_b;

    output reg [1:0] o_mem_to_reg;
    output reg [1:0] o_reg_dst;
    output reg [2:0] o_branch;
    output reg [3:0] o_alu_op;
    output reg [4:0] o_shamt;
    output reg [4:0] o_rs;
    output reg [4:0] o_rt;
    output reg [4:0] o_rd;
    output reg [5:0] o_funct;
    output reg [31:0] o_pc_4;
    output reg [31:0] o_data_1;
    output reg [31:0] o_data_2;
    output reg [31:0] o_imm_ext;
    output reg [31:0] o_imm_ext_shift;
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_reg_write     <= 0;
            o_mem_read      <= 0;
            o_mem_write     <= 0;
            o_alu_src_a     <= 0;
            o_alu_src_b     <= 0;
            o_branch        <= 0;
            o_pc_4          <= 0;
            o_data_1        <= 0;
            o_data_2        <= 0;
            o_mem_to_reg    <= 0;
            o_reg_dst       <= 0;
            o_alu_op        <= 0;
            o_rs            <= 0;
            o_rt            <= 0;
            o_rd            <= 0;
            o_shamt         <= 0;
            o_funct         <= 0;
            o_imm_ext       <= 0;
            o_imm_ext_shift <= 0;
        end
        else begin
            if(i_flush) begin // In fact, we only have to set RegWrite and MemWrite to 0 when flush
                o_reg_write <= 0;
                o_mem_write <= 0;
            end
            else begin
                o_reg_write <= i_reg_write;
                o_mem_write <= i_mem_write;
            end
            
            o_mem_read      <= i_mem_read;
            o_alu_src_a     <= i_alu_src_a;
            o_alu_src_b     <= i_alu_src_b;
            o_branch        <= i_branch;
            o_pc_4          <= i_pc_4 ;
            o_data_1        <= i_data_1;
            o_data_2        <= i_data_2 ;
            o_mem_to_reg    <= i_mem_to_reg;
            o_reg_dst       <= i_reg_dst;
            o_alu_op        <= i_alu_op ;
            o_rs            <= i_rs;
            o_rt            <= i_rt;
            o_rd            <= i_rd;
            o_shamt         <= i_shamt;
            o_funct         <= i_funct;
            o_imm_ext       <= i_imm_ext;
            o_imm_ext_shift <= i_imm_ext_shift;
        end
    end
endmodule
