`timescale 1ns / 1ps

module BCD7(reset,
            clk,
            i_data,
            o_data);
    
    input reset;
    input clk;
    input [31:0] i_data;
    output reg [11:0] o_data;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_data <= 12'b111111111111;
        end
        else begin
            o_data <= i_data[11:0];
        end
    end
    
endmodule
