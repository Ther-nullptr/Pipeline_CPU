`timescale 1ns / 1ps
module ALU(i_alu_conf,
           i_sign,
           i_data_1,
           i_data_2,
           o_relation,
           o_result);
    
    // Control Signals
    input [4:0] i_alu_conf;
    input i_sign;
    // Input Data Signals
    input [31:0] i_data_1;
    input [31:0] i_data_2;
    // Result output
    output reg [1:0] o_relation;
    output reg [31:0] o_result;
    
    // i_alu_conf signal
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
    
    // useful for branch control
    always @(*) begin
        if (o_result < 0)begin
            o_relation <= 2'b00; // <
        end
        else if (o_result > 0)begin
            o_relation <= 2'b01; // >
        end
        else begin
            o_relation <= 2'b10; // = 
        end
    end
    
    // IMPORTANT! although the signed and unsigned settings has different results in +,-,&,|..., but they share the same representations
    // However, when it comes to slt and sra, they will produce different o_result performance
    always @(*) begin
        case(i_alu_conf)
            AND_CONF: o_result <= i_data_1 & i_data_2;
            OR_CONF: o_result  <= i_data_1 | i_data_2;
            ADD_CONF: o_result <= i_data_1 + i_data_2;
            SUB_CONF: o_result <= i_data_1 - i_data_2;
            SLT_CONF: begin
                if (i_sign) begin //signed
                    case({i_data_1[31],i_data_2[31]}) // to compare according to the sign bit
                        2'b01: o_result <= 0;
                        2'b10: o_result <= 1;
                        2'b00: o_result <= (i_data_1<i_data_2);
                        2'b11: o_result <= (i_data_1[30:0]<i_data_2[30:0]);
                    endcase
                end
                else // unsigned
                o_result <= (i_data_1 < i_data_2);
            end
            NOR_CONF: o_result <= ~(i_data_1 | i_data_2);
            XOR_CONF: o_result <= (i_data_1 ^ i_data_2);
            SLL_CONF: o_result <= (i_data_2 << i_data_1);
            SRL_CONF: o_result <= (i_data_2 >> i_data_1);
            // important!! if you want to add shamt options, you should load the last 16 bits and get the shamt[10:6]
            SRA_CONF: o_result <= ({{32{i_data_2[31]}}, i_data_2} >> i_data_1); // the highst bit is always same as signal-bit
            // when it comes to unsigned numbers, sra_ctrl may get wrong answers
            default: o_result <= 0;
        endcase
    end
endmodule
