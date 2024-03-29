`timescale 1ns / 1ps
module IF_ID_Register(reset,
                      clk,
                      i_pc_4,
                      i_instruction,
                      i_flush,
                      i_keep,
                      o_pc_4,
                      o_instruction);
    input reset;
    input clk;
    input i_flush;
    input i_keep;
    input [31:0] i_pc_4;
    input [31:0] i_instruction;
    
    output reg [31:0] o_pc_4;
    output reg [31:0] o_instruction;
    
    reg [31:0] num;
    initial begin
        num <= 0;
    end
    
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            o_pc_4        <= 32'b0;
            o_instruction <= 32'b0;
        end
        else begin
            if (i_keep) begin
                o_instruction <= o_instruction;
                o_pc_4        <= o_pc_4;
            end
            else begin // a 'nop' command is generated by hazard unit
                if (i_flush) begin
                    o_instruction <= 32'b0;
                end
                else begin
                    o_instruction <= i_instruction;
                end
                o_pc_4 <= i_pc_4;
                num <= num + 1;
            end
        end
    end
    
endmodule
