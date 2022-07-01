`timescale 1ns / 1ps
module ALU(ALUConf,
           Sign,
           in1,
           in2,
           relation,
           result);
    
    // Control Signals
    input [4:0] ALUConf;
    input Sign;
    // Input Data Signals
    input [31:0] in1;
    input [31:0] in2;
    // Result output
    output reg [1:0] relation;
    output reg [31:0] result;
    
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
    
    // useful for branch control
    always @(*) begin
        if (result < 0)begin
            relation <= 2'b00; // <
        end
        else if (result > 0)begin
            relation <= 2'b01; // >
        end
        else begin
            relation <= 2'b10; // = 
        end
    end
    
    // IMPORTANT! although the signed and unsigned settings has different results in +,-,&,|..., but they share the same representations
    // However, when it comes to slt and sra, they will produce different result performance
    always @(*) begin
        case(ALUConf)
            AND_CONF: result <= in1 & in2;
            OR_CONF: result  <= in1 | in2;
            ADD_CONF: result <= in1 + in2;
            SUB_CONF: result <= in1 - in2;
            SLT_CONF: begin
                if (Sign) begin //signed
                    case({in1[31],in2[31]}) // to compare according to the sign bit
                        2'b01: result <= 0;
                        2'b10: result <= 1;
                        2'b00: result <= (in1<in2);
                        2'b11: result <= (in1[30:0]<in2[30:0]);
                    endcase
                end
                else // unsigned
                result <= (in1 < in2);
            end
            NOR_CONF: result <= ~(in1 | in2);
            XOR_CONF: result <= (in1 ^ in2);
            SLL_CONF: result <= (in2 << in1);
            SRL_CONF: result <= (in2 >> in1);
            // important!! if you want to add shamt options, you should load the last 16 bits and get the shamt[10:6]
            SRA_CONF: result <= ({{32{in2[31]}}, in2} >> in1); // the highst bit is always same as signal-bit
            // when it comes to unsigned numbers, sra_ctrl may get wrong answers
            default: result <= 0;
        endcase
    end
endmodule
