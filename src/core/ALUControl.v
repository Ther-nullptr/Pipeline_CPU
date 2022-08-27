`timescale 1ns / 1ps
module ALUControl(i_aluop,
                  i_funct,
                  o_aluconf,
                  o_sign);
    //Control Signals
    input [2:0] i_aluop;
    //Inst. Signals
    input [5:0] i_funct;
    //Output Control Signals
    output reg [3:0] o_aluconf;
    output reg o_sign;
    
    // MIPS Functs
    parameter ADD_FUN  = 6'h20;
    parameter ADDU_FUN = 6'h21;
    parameter SUB_FUN  = 6'h22;
    parameter SUBU_FUN = 6'h23;
    
    parameter AND_FUN = 6'h24;
    parameter OR_FUN  = 6'h25;
    parameter XOR_FUN = 6'h26;
    parameter NOR_FUN = 6'h27;
    
    parameter SLL_FUN  = 6'h00;
    parameter SRL_FUN  = 6'h02;
    parameter SRA_FUN  = 6'h03;
    parameter SLT_FUN  = 6'h2a;
    parameter SLTU_FUN = 6'h2b;
    
    parameter JR_FUN   = 6'h08;
    parameter JALR_FUN = 6'h09;
    
    // i_aluop
    parameter I1_ALUOP  = 3'b000; // I type: lw,sw
    parameter I2_ALUOP  = 3'b001; // I type: beq and other branch commands
    parameter R_ALUOP   = 3'b010; // R type
    parameter AND_ALUOP = 3'b011; // andi
    parameter SLT_ALUOP = 3'b100; // slti, sltiu
    
    // o_aluconf signal
    parameter AND_CONF = 4'b0000; // &
    parameter OR_CONF  = 4'b0001; // |
    parameter ADD_CONF = 4'b0010; // +
    parameter SUB_CONF = 4'b0011; // -
    parameter SLT_CONF = 4'b0100; // set on less than
    parameter NOR_CONF = 4'b0101; // nor
    parameter XOR_CONF = 4'b0110; // xor
    parameter SLL_CONF = 4'b0111; // <<
    parameter SRL_CONF = 4'b1000; // >>
    parameter SRA_CONF = 4'b1001; // >>(a)

    initial begin
        o_sign <= 1;
    end
    
    // step 1: to decide the signed & unsigned
    // I & R type
    always @(*) begin
        case(i_aluop)
        R_ALUOP: begin
            case(i_funct)
                ADDU_FUN,SUBU_FUN,SLTU_FUN: o_sign <= 0;
                default: o_sign                    <= 1;
            endcase
        end
        default:o_sign <= 1;
        endcase
    end

    always @(*) begin
        case(i_aluop)
        R_ALUOP:begin // R type, decide the o_aluconf by i_funct
            case(i_funct)
                ADD_FUN,ADDU_FUN:o_aluconf  <= ADD_CONF;
                SUB_FUN,SUBU_FUN:o_aluconf  <= SUB_CONF;
                AND_FUN:o_aluconf <= AND_CONF;
                OR_FUN:o_aluconf  <= OR_CONF;
                XOR_FUN:o_aluconf <= XOR_CONF;
                NOR_FUN:o_aluconf <= NOR_CONF;
                SLT_FUN,SLTU_FUN:o_aluconf  <= SLT_CONF;
                SLL_FUN:o_aluconf  <= SLL_CONF;
                SRL_FUN:o_aluconf  <= SRL_CONF;
                SRA_FUN:o_aluconf  <= SRA_CONF;
                default:o_aluconf  <= ADD_CONF;
            endcase
        end
        I1_ALUOP: // use add
            o_aluconf <= ADD_CONF;
        I2_ALUOP: // use sub
            o_aluconf <= SUB_CONF;
        AND_ALUOP: // use and
            o_aluconf <= AND_CONF;
        SLT_ALUOP: // use slt
            o_aluconf <= SLT_CONF;
        default:
            o_aluconf <= ADD_CONF;
        endcase
    end
    
endmodule
