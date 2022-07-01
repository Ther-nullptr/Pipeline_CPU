`timescale 1ns / 1ps
module Control(OpCode,
               Funct,
               PCSource,
               Branch,
               RegWrite,
               RegDst,
               MemRead,
               MemWrite,
               MemtoReg,
               ALUSrcA,
               ALUSrcB,
               ALUOp,
               ExtOp,
               LuiOp);
    
    input [5:0] OpCode;
    input [5:0] Funct;
    
    
    
    output reg RegWrite;
    output reg MemRead;
    output reg MemWrite;
    output reg ALUSrcA;
    output reg ALUSrcB;
    output reg ExtOp;
    output reg LuiOp;
    
    output reg [1:0] MemtoReg;
    output reg [1:0] RegDst;
    output reg [1:0] PCSource;
    
    output reg [2:0] ALUOp;
    output reg [2:0] Branch;
    
    // MIPS Opcodes
    parameter LW_OP  = 6'h23; // load word(I)
    parameter SW_OP  = 6'h2b; // save word(I)
    parameter LUI_OP = 6'h0f; // load upper 16 bits of immediate(I)
    
    parameter ADDI_OP  = 6'h08; // add immediate(I)
    parameter ADDIU_OP = 6'h09; // add immediate unsigned #! u(I)
    
    parameter ANDI_OP  = 6'h0c; // and immediate(I)
    parameter SLTI_OP  = 6'h0a; // set on less than immediate(I)
    parameter SLTIU_OP = 6'h0b; // set on less than immediate unsigned #! u(I)
    
    parameter BEQ_OP  = 6'h04; // branch on equal(I)
    parameter BNE_OP  = 6'h05; // branch on not equal(I)
    parameter BLEZ_OP = 6'h06; // branch on < = 0(I)
    parameter BGTZ_OP = 6'h07; // branch on >0(I)
    parameter BLTZ_OP = 6'h08; // branch on <0(I)
    
    parameter J_OP   = 6'h02; // jump(J)
    parameter JAL_OP = 6'h03; // jump and link(J)
    
    parameter R_OP = 6'h00; // represent for all R-types
    
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
    
    initial begin
        PCSource <= 0;
        Branch   <= 0;
        RegWrite <= 0;
        RegDst   <= 0;
        MemRead  <= 0;
        MemWrite <= 0;
        MemtoReg <= 0;
        ALUSrcA  <= 0;
        ALUSrcB  <= 0;
        ExtOp    <= 0;
        LuiOp    <= 0;
    end
    
    // generate control signals
    always @(*) begin
        // PCSource
        case(OpCode)
            J_OP,JAL_OP: begin
                PCSource <= 2'b01; // from imm
            end
            
            R_OP: begin
                case(Funct)
                    JR_FUN,JALR_FUN:begin
                        PCSource <= 2'b10; // from reg
                    end
                    default:begin
                        PCSource <= 2'b00; // from PC+4
                    end
                endcase
            end
            
            default: begin
                PCSource <= 2'b00; // from PC+4
            end
        endcase
        
        // Branch
        case(OpCode)
            BEQ_OP:begin
                Branch <= 3'b001;
            end

            BNE_OP:begin
                Branch <= 3'b010;
            end

            BLEZ_OP:begin
                Branch <= 3'b011;
            end

            BGTZ_OP:begin
                Branch <= 3'b100;
            end

            BLTZ_OP:begin
                Branch <= 3'b101;
            end
            
            default:begin
                Branch <= 3'b000;
            end
        endcase
        
        // RegWrite
        case(OpCode)
            SW_OP,BEQ_OP,BNE_OP,BLEZ_OP,BGTZ_OP,BLTZ_OP,J_OP:begin
                RegWrite <= 0;
            end
            
            R_OP:begin
                case(Funct)
                    JR_FUN:begin
                        RegWrite <= 0;
                    end
                    default:begin
                        RegWrite <= 1;
                    end
                endcase
            end
            
            default:begin
                RegWrite <= 1;
            end
        endcase
        
        // RegDst
        case(OpCode)
            R_OP:begin
                case(Funct)
                    JALR_FUN:begin
                        RegDst <= 2'b10; // $31
                    end
                    default:begin
                        RegDst <= 2'b01; // Rd
                    end
                endcase
            end
            
            JAL_OP:begin
                RegDst <= 2'b10; // $31
            end
            
            default:begin
                RegDst <= 2'b00; // Rt
            end
        endcase
        
        // MemRead
        case(OpCode)
            LW_OP:begin
                MemRead <= 1;
            end
            
            default:begin
                MemRead <= 0;
            end
        endcase
        
        // MemWrite
        case(OpCode)
            SW_OP:begin
                MemWrite <= 1;
            end
            
            default:begin
                MemWrite <= 0;
            end
        endcase
        
        // MemtoReg
        case(OpCode)
            LW_OP:begin
                MemtoReg <= 2'b01;
            end
            
            JAL_OP:begin
                MemtoReg <= 2'b10;
            end
            
            LUI_OP:begin
                MemtoReg <= 2'b11;
            end
            
            R_OP:begin
                case(Funct)
                    JALR_FUN:begin
                        MemtoReg <= 2'b10;
                    end
                    default:begin
                        MemtoReg <= 2'b00;
                    end
                endcase
            end
            
            default:begin
                MemtoReg <= 2'b00;
            end
        endcase
        
        // ALUSrcA
        case(OpCode)
            R_OP:begin
                case(Funct)
                    SLL_FUN,SRL_FUN,SRA_FUN:begin
                        ALUSrcA <= 1;
                    end
                    default:begin
                        ALUSrcA <= 0;
                    end
                endcase
            end
            
            default:begin
                ALUSrcA <= 0;
            end
        endcase
        
        // ALUSrcB
        case(OpCode)
            R_OP,BEQ_OP,BNE_OP,BLEZ_OP,BGTZ_OP,BLTZ_OP:begin
                ALUSrcB <= 0;
            end
            
            default:begin
                ALUSrcB <= 1;
            end
        endcase
        
        // ExtOp
        case(OpCode)
            ANDI_OP:begin
                ExtOp <= 0;
            end
            
            default:begin
                ExtOp <= 1;
            end
        endcase
        
        // LuiOp
        case(OpCode)
            LUI_OP:begin
                LuiOp <= 1;
            end
            
            default:begin
                LuiOp <= 0;
            end
        endcase
    end
    
    // generate ALUOp
    parameter I1_ALUOP  = 3'b000; // I type: lw,sw(use add)
    parameter I2_ALUOP  = 3'b001; // I type: beq(use sub)
    parameter R_ALUOP   = 3'b010; // R type
    parameter AND_ALUOP = 3'b011; // andi
    parameter SLT_ALUOP = 3'b100; // slti, sltiu
    
    always @(*) begin
        case(OpCode)
            LW_OP,SW_OP,LUI_OP,ADDI_OP,ADDIU_OP:ALUOp <= I1_ALUOP;
            BEQ_OP,BNE_OP,BLEZ_OP,BGTZ_OP,BLTZ_OP:ALUOp <= I2_ALUOP;
            ANDI_OP:ALUOp <= AND_ALUOP;
            SLTI_OP,SLTIU_OP:ALUOp <= SLT_ALUOP;
            default:ALUOp <= R_ALUOP;
        endcase
    end
    
endmodule
