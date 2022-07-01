module ALUControl(ALUOp,
                  funct,
                  ALUConf,
                  sign);
    //Control Signals
    input [2:0] ALUOp;
    //Inst. Signals
    input [5:0] funct;
    //Output Control Signals
    output reg [3:0] ALUConf;
    output reg sign;
    
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
    
    // ALUOp
    parameter I1_ALUOP  = 3'b000; // I type: lw,sw
    parameter I2_ALUOP  = 3'b001; // I type: beq, and other branch commands
    parameter R_ALUOP   = 3'b010; // R type
    parameter AND_ALUOP = 3'b011; // andi
    parameter SLT_ALUOP = 3'b100; // slti, sltiu
    
    // ALUConf signal
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
    
    // step 1: to decide the signed & unsigned
    // I & R type
    always @(*) begin
        if (ALUOp == R_ALUOP) begin
            case(funct)
                ADDU_FUN,SUBU_FUN,SLTU_FUN: sign <= 0;
                default: sign                    <= 1;
            endcase
        end
    end
    
    // step 2: generate ALUConf according to funct
    always @(*) begin
        if (ALUOp == R_ALUOP) begin // R type, decide the ALUConf by funct
            case(funct)
                ADD_FUN,ADDU_FUN:ALUConf  <= ADD_CONF;
                SUB_FUN,SUBU_FUN:ALUConf  <= SUB_CONF;
                AND_FUN:ALUConf <= AND_CONF;
                OR_FUN:ALUConf  <= OR_CONF;
                XOR_FUN:ALUConf <= XOR_CONF;
                NOR_FUN:ALUConf <= NOR_CONF;
                SLT_FUN,SLTU_FUN:ALUConf  <= SLT_CONF;
                SLL_FUN:ALUConf  <= SLL_CONF;
                SRL_FUN:ALUConf  <= SRL_CONF;
                SRA_FUN:ALUConf  <= SRA_CONF;
            endcase
        end
        else if (ALUOp == I1_ALUOP) // use add
            ALUConf <= ADD_CONF;
        else if (ALUOp == I2_ALUOP) // use sub
            ALUConf <= SUB_CONF;
        else if (ALUOp == AND_ALUOP) // use and
            ALUConf <= AND_CONF;
        else if (ALUOp == SLT_ALUOP) // use slt
            ALUConf <= SLT_CONF;
        else
            ALUConf <= ADD_CONF;
    end
    
endmodule
