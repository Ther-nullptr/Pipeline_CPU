`timescale 1ns / 1ps
module PC(reset,
          clk,
          i_pc_keep,
          i_pc,
          o_pc);
    
    //Input Clock Signals
    input reset;
    input clk;
    
    //Input Control
    input i_pc_keep;
    
    //Input PC
    input [31:0] i_pc;
    //Output PC
    output reg [31:0] o_pc;
    
    reg [31:0] num;
    
    initial begin
        o_pc <= 0;
    end
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            o_pc <= 0;
        end
        else if (i_pc_keep) begin
            o_pc <= o_pc;
        end
        else begin
            o_pc <= i_pc;
        end
    end
    
endmodule
