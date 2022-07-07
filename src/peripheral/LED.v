`timescale 1ns / 1ps

module LED(reset,
            clk,
            i_data,
            o_data);
    
    input reset;
    input clk;
    input [31:0] i_data;
    output reg [7:0] o_data;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_data <= 7'b0000000;
        end
        else begin
            o_data <= i_data[7:0];
        end
    end
    
endmodule
