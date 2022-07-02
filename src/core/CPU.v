`timescale 1ns / 1ps

// only useful in vscode:
`include "InstructionMemory.v"
`include "PC.v"
`include "IF_ID_Register.v"
`include "RegisterFile.v"
`include "Control.v"
`include "ImmediateExtension.v"
`include "Hazard.v"
`include "ID_EX_Register.v"
`include "ALUControl.v"
`include "ALU.v"
`include "BranchControl.v"
`include "EX_Forward.v"
`include "EX_MEM_Register.v"
`include "DataMemory.v"
`include "MEM_Forward.v"
`include "MEM_WB_Register.v"

module CPU(reset,
           clk);
    input reset;
    input clk;
    
    //-------------------IF-------------------
    
    wire [31:0] i_pc;
    wire [31:0] o_pc;
    wire [31:0] pc_IF;
    wire pc_keep;
    
    /* module:PC */
    PC U_PC(
    .reset(reset),
    .clk(clk),
    .i_pc_keep(pc_keep),
    .i_pc(i_pc),
    .o_pc(o_pc)
    );
    
    assign pc_IF = o_pc + 4;
    
    wire [31:0] instruction_IF;
    
    /* module:Instruction Memory */
    InstructionMemory U_InstructionMemory(
    .i_address(o_pc),
    .o_instruction(instruction_IF)
    );
    
    wire flush_IF_ID;
    wire keep_IF_ID;
    wire [31:0] instruction_ID;
    wire [31:0] pc_ID;
    
    /* module:IF/ID Reg */
    IF_ID_Register U_IF_ID_Register(
    .reset(reset),
    .clk(clk),
    .i_pc_4(pc_IF),
    .i_instruction(instruction_IF),
    .i_flush(flush_IF_ID),
    .o_pc_4(pc_ID),
    .o_instruction(instruction_ID)
    );
    
    //-------------------ID-------------------
    
    wire reg_write_ID;
    wire mem_read_ID;
    wire mem_write_ID;
    wire alu_src_a_ID;
    wire alu_src_b_ID;
    wire jump_ID;
    wire ext_op_ID;
    wire lui_op_ID;
    
    wire [1:0] mem_to_reg_ID;
    wire [1:0] reg_dst_ID;
    wire [1:0] pc_source_ID;
    
    wire [2:0] alu_op_ID;
    wire [2:0] branch_ID;
    
    wire [5:0] opcode;
    wire [4:0] rs_ID;
    wire [4:0] rt_ID;
    wire [4:0] rd_ID;
    wire [4:0] shamt_ID;
    wire [5:0] funct_ID;
    
    wire [15:0] immediate_ID;
    wire [25:0] imm_address_ID;
    
    assign opcode         = instruction_ID[31:26];
    assign rs_ID          = instruction_ID[25:21];
    assign rt_ID          = instruction_ID[20:16];
    assign rd_ID          = instruction_ID[15:11];
    assign shamt_ID       = instruction_ID[10:6];
    assign funct_ID       = instruction_ID[5:0];
    assign immediate_ID   = {rd_ID,shamt_ID,funct_ID};
    assign imm_address_ID = {rs_ID,rt_ID,immediate_ID};
    
    wire [4:0] write_register_WB;
    wire [31:0] write_register_data_WB;
    wire [31:0] read_data_1_ID;
    wire [31:0] read_data_2_ID;
    
    /* module:Control */
    Control U_Control(
    .OpCode(opcode),
    .Funct(funct_ID),
    .PCSource(pc_source_ID),
    .Branch(branch_ID),
    .RegWrite(reg_write_ID),
    .RegDst(reg_dst_ID),
    .MemRead(mem_read_ID),
    .MemWrite(mem_write_ID),
    .MemtoReg(mem_to_reg_ID),
    .ALUSrcA(alu_src1),
    .ALUSrcB(alu_src2),
    .Jump(jump_ID),
    .ALUOp(alu_op_ID),
    .ExtOp(ext_op_ID),
    .LuiOp(lui_op_ID)
    );
    
    /* module:Register File */
    RegisterFile U_RegisterFile(
    .reset(reset),
    .clk(clk),
    .i_reg_write(reg_write_ID),
    .i_read_register1(rs_ID),
    .i_read_register2(rt_ID),
    .i_write_register(write_register_WB),
    .i_write_data(write_register_data_WB),
    .o_read_data1(read_data_1_ID),
    .o_read_data2(read_data_2_ID)
    );
    
    // generate jump address
    wire [31:0] jump_address;
    assign jump_address = {pc_ID[31:28],imm_address_ID,2'b00};
    
    wire [31:0] imm_ext_out_ID;
    wire [31:0] imm_ext_shift_ID;
    
    /* module Immediate Extension*/
    ImmediateExtension U_ImmediateExtension(
    .i_extop(ext_op_ID),
    .i_luiop(lui_op_ID),
    .i_immediate(immediate_ID),
    .o_imm_ext(imm_ext_out_ID),
    .o_imm_ext_shift(imm_ext_shift_ID)
    );
    
    wire flush_ID_EX;
    wire reg_write_EX;
    wire mem_read_EX;
    wire mem_write_EX;
    wire alu_src_a_EX;
    wire alu_src_b_EX;
    wire ext_op_EX;
    wire lui_op_EX;
    
    wire [1:0] mem_to_reg_EX;
    wire [1:0] reg_dst_EX;
    
    wire [2:0] alu_op_EX;
    wire [2:0] branch_EX;
    
    wire [4:0] rs_EX;
    wire [4:0] rt_EX;
    wire [4:0] rd_EX;
    wire [4:0] shamt_EX;
    wire [5:0] funct_EX;
    
    wire [31:0] pc_EX;
    wire [31:0] read_data_1_EX;
    wire [31:0] read_data_2_EX;
    wire [31:0] imm_ext_out_EX;
    wire [31:0] imm_ext_shift_EX;
    
    /* module:ID/EX Reg*/
    ID_EX_Register U_ID_EX_Register(
    .reset(reset),
    .clk(clk),
    .i_flush(flush_ID_EX),
    .i_reg_write(reg_write_ID),
    .i_mem_to_reg(mem_to_reg_ID),
    .i_mem_read(mem_read_ID),
    .i_mem_write(mem_write_ID),
    .i_reg_dst(reg_dst_ID),
    .i_alu_op(alu_op_ID),
    .i_alu_src_a(alu_src_a_ID),
    .i_alu_src_b(alu_src_b_ID),
    .i_branch(branch_ID),
    .i_pc_4(pc_ID),
    .i_data_1(read_data_1_ID),
    .i_data_2(read_data_2_ID),
    .i_imm_ext(imm_ext_out_ID),
    .i_imm_ext_shift(imm_ext_shift_ID),
    .i_rs(rs_ID),
    .i_rt(rt_ID),
    .i_rd(rd_ID),
    .i_shamt(shamt_ID),
    .i_funct(funct_ID),
    .o_reg_write(reg_write_EX),
    .o_mem_to_reg(mem_to_reg_EX),
    .o_mem_read(mem_read_EX),
    .o_mem_write(mem_write_EX),
    .o_reg_dst(reg_dst_EX),
    .o_alu_op(alu_op_EX),
    .o_alu_src_a(alu_src_a_EX),
    .o_alu_src_b(alu_src_b_EX),
    .o_branch(branch_EX),
    .o_pc_4(pc_EX),
    .o_data_1(read_data_1_EX),
    .o_data_2(read_data_2_EX),
    .o_imm_ext(imm_ext_out_EX),
    .o_imm_ext_shift(imm_ext_shift_EX),
    .o_rs(rs_EX),
    .o_rt(rt_EX),
    .o_rd(rd_EX),
    .o_shamt(shamt_EX),
    .o_funct(funct_EX)
    );
    
    /* module:Hazard Unit*/
    Hazard U_Hazard(
    .i_ID_EX_mem_read(mem_read_EX),
    .i_ID_EX_Rt(rt_EX),
    .i_IF_ID_Rs(rs_ID),
    .i_IF_ID_Rt(rt_ID),
    .i_branch(branch_ID),
    .i_jump(jump_ID),
    .o_IF_ID_flush(flush_IF_ID),
    .o_ID_EX_flush(flush_ID_EX),
    .o_IF_ID_keep(keep_IF_ID),
    .o_pc_keep(pc_keep)
    );
    
    //-------------------EX-------------------
    wire [3:0] alu_conf;
    wire sign;
    
    /* module:ALU Control*/
    ALUControl U_ALUControl(
    .i_aluop(alu_op_EX),
    .i_funct(funct_EX),
    .o_aluconf(alu_conf),
    .o_sign(sign)
    );
    
    wire [31:0] alu_in1;
    wire [31:0] alu_in2;
    wire [31:0] alu_out_EX;
    wire [1:0] relation;
    wire branch_final;
    
    /* module:ALU */
    ALU U_ALU(
    .i_alu_conf(alu_conf),
    .i_sign(sign),
    .i_data_1(alu_in1),
    .i_data_2(alu_in2),
    .o_relation(relation),
    .o_result(alu_out_EX)
    );
    
    /* module: BranchControl*/
    BranchControl U_BranchControl(
    .i_relation(relation),
    .i_branch(branch_EX),
    .o_branch(branch_final)
    );
    
    wire [4:0] rd_MEM;
    wire [4:0] rd_WB;
    
    wire reg_write_MEM;
    wire reg_write_WB;
    wire [1:0] forward_A_EX;
    wire [1:0] forward_B_EX;
    
    /* module: EX Forward Unit*/
    EX_Forward U_EX_Forward(
    .i_ID_EX_Rs(rs_EX),
    .i_ID_EX_Rt(rt_EX),
    .i_EX_MEM_Rd(rd_MEM),
    .i_MEM_WB_Rd(rd_WB),
    .i_EX_MEM_reg_write(reg_write_MEM),
    .i_MEM_WB_reg_write(reg_write_WB),
    .o_forward_A(forward_A_EX),
    .o_forward_B(forward_B_EX)
    );
    
    // generate branch address
    wire [31:0] branch_address;
    assign branch_address = pc_EX+imm_ext_shift_EX;
    
    wire mem_read_MEM;
    wire mem_write_MEM;
    wire [1:0] mem_to_reg_MEM;
    wire [4:0] write_register_EX;
    wire [4:0] write_register_MEM;
    wire [4:0] rt_MEM;
    wire [31:0] pc_MEM;
    wire [31:0] read_data_2_MEM;
    wire [31:0] imm_ext_out_MEM;
    wire [31:0] alu_out_MEM;
    
    /* module:EX/MEM Reg*/
    EX_MEM_Register U_EX_MEM_Register(
    .reset(reset),
    .clk(clk),
    .i_reg_write(reg_write_EX),
    .i_mem_to_reg(mem_to_reg_EX),
    .i_mem_read(mem_read_EX),
    .i_mem_write(mem_write_EX),
    .i_pc_4(pc_EX),
    .i_data_2(read_data_2_EX),
    .i_imm_ext(imm_ext_out_EX),
    .i_write_register(write_register_EX),
    .i_rt(rt_EX),
    .i_rd(rd_EX),
    .i_alu_result(alu_out_EX),
    .o_reg_write(reg_write_MEM),
    .o_mem_to_reg(mem_to_reg_MEM),
    .o_mem_read(mem_read_MEM),
    .o_mem_write(mem_write_MEM),
    .o_pc_4(pc_MEM),
    .o_data_2(read_data_2_MEM),
    .o_imm_ext(imm_ext_out_MEM),
    .o_write_register(write_register_MEM),
    .o_rt(rt_MEM),
    .o_rd(rd_MEM),
    .o_alu_result(alu_out_MEM)
    );
    
    /* mux */
    
    assign write_register_EX = (reg_dst_EX == 2'b00)?rt_EX:
    (reg_dst_EX == 2'b01)?rd_EX:
    (reg_dst_EX == 2'b10)?5'b11111:
    rt_EX;
    
    wire [31:0] w_result_1;
    wire [31:0] w_result_2;
    
    assign w_result_1 = (forward_A_EX == 2'b00)?read_data_1_EX:
    (forward_A_EX == 2'b01)?alu_out_MEM:
    (forward_A_EX == 2'b10)?write_register_data_WB:
    read_data_1_EX;
    
    assign w_result_2 = (forward_B_EX == 2'b00)?read_data_2_EX:
    (forward_B_EX == 2'b01)?alu_out_MEM:
    (forward_B_EX == 2'b10)?write_register_data_WB:
    read_data_2_EX;
    
    assign alu_in1 = (alu_src_a_EX == 0)?w_result_1:shamt_EX;
    assign alu_in2 = (alu_src_b_EX == 0)?w_result_2:imm_ext_out_EX;
    
    //-------------------MEM------------------
    wire [31:0] mem_read_data_MEM;
    wire [31:0] mem_write_data;
    /* module:Data Memory*/
    DataMemory U_DataMemory(
    .reset(reset),
    .clk(clk),
    .i_address(alu_out_MEM),
    .i_mem_write_data(mem_write_data),
    .i_mem_read(mem_read_MEM),
    .i_mem_write(mem_write_MEM),
    .o_mem_read_data(mem_read_data_MEM)
    );
    
    wire mem_read_WB;
    wire forward_MEM;
    wire [4:0] rt_WB;
    
    /* module:MEM Forward Unit*/
    MEM_Forward U_MEM_Forward(.i_EX_MEM_Rt(rt_MEM),
    .i_MEM_WB_Rt(rt_WB),
    .i_EX_MEM_mem_write(mem_write_MEM),
    .i_MEM_WB_mem_read(mem_read_WB),
    .o_forward(forward_MEM));
    
    wire [1:0] mem_to_reg_WB;
    wire [31:0] alu_out_WB;
    wire [31:0] mem_read_data_WB;
    wire [31:0] pc_WB;
    wire [31:0] imm_ext_out_WB;
    
    /* module:MEM/WB Reg*/
    MEM_WB_Register U_MEM_WB_Register(
    .reset(reset),
    .clk(clk),
    .i_result(alu_out_MEM),
    .i_mem_read_data(mem_read_data_MEM),
    .i_pc_4(pc_MEM),
    .i_imm_ext_out(imm_ext_out_MEM),
    .i_reg_write(reg_write_MEM),
    .i_mem_to_reg(mem_to_reg_MEM),
    .i_mem_read(mem_read_MEM),
    .o_result(alu_out_WB),
    .o_mem_read_data(mem_read_data_WB),
    .o_pc_4(pc_WB),
    .o_imm_ext_out(imm_ext_out_WB),
    .o_reg_write(reg_write_WB),
    .o_mem_to_reg(mem_to_reg_WB),
    .o_mem_read(mem_read_WB)
    );
    
    /* mux */
    assign mem_write_data = (forward_MEM == 0)?read_data_2_MEM:write_register_data_WB;
    
    //-------------------WB-------------------
    
    /* mux */
    assign write_register_data_WB = (mem_to_reg_WB == 2'b00)?alu_out_WB:
    (mem_to_reg_WB == 2'b01)?mem_read_data_WB:
    (mem_to_reg_WB == 2'b10)?pc_WB:
    (mem_to_reg_WB == 2'b11)?imm_ext_out_WB:
    alu_out_WB;
    
    wire [31:0] w_pc;
    assign w_pc = (pc_source_ID == 2'b00)?pc_IF:
    (pc_source_ID == 2'b01)?jump_address:
    (pc_source_ID == 2'b10)?read_data_1_ID:
    pc_IF;
    
    assign i_pc = (branch_final == 0)?w_pc:branch_address;
    
endmodule
