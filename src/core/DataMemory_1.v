`timescale 1ns / 1ps
module DataMemory(clk,
                  i_address,
                  i_mem_write_data,
                  i_mem_write,
                  i_mem_read,
                  o_mem_read_data);
    
    input clk;
    input i_mem_read, i_mem_write;
    input [8:0] i_address;
    input [31:0] i_mem_write_data;
    output [31:0] o_mem_read_data;
    
    parameter RAM_SIZE = 1024;
    
    reg [31:0] RAM_data[RAM_SIZE - 1: 0];
    
    initial begin
        RAM_data[10'd0]  <= 32'd108;
        RAM_data[10'd1]  <= 32'd105;
        RAM_data[10'd2]  <= 32'd110;
        RAM_data[10'd3]  <= 32'd117;
        RAM_data[10'd4]  <= 32'd120;
        RAM_data[10'd5]  <= 32'd32;
        RAM_data[10'd6]  <= 32'd105;
        RAM_data[10'd7]  <= 32'd115;
        RAM_data[10'd8]  <= 32'd32;
        RAM_data[10'd9]  <= 32'd110;
        RAM_data[10'd10] <= 32'd111;
        RAM_data[10'd11] <= 32'd116;
        RAM_data[10'd12] <= 32'd32;
        RAM_data[10'd13] <= 32'd117;
        RAM_data[10'd14] <= 32'd110;
        RAM_data[10'd15] <= 32'd105;
        RAM_data[10'd16] <= 32'd120;
        RAM_data[10'd17] <= 32'd32;
        RAM_data[10'd18] <= 32'd105;
        RAM_data[10'd19] <= 32'd115;
        RAM_data[10'd20] <= 32'd32;
        RAM_data[10'd21] <= 32'd110;
        RAM_data[10'd22] <= 32'd111;
        RAM_data[10'd23] <= 32'd116;
        RAM_data[10'd24] <= 32'd32;
        RAM_data[10'd25] <= 32'd117;
        RAM_data[10'd26] <= 32'd110;
        RAM_data[10'd27] <= 32'd105;
        RAM_data[10'd28] <= 32'd120;
        RAM_data[10'd29] <= 32'd32;
        RAM_data[10'd30] <= 32'd105;
        RAM_data[10'd31] <= 32'd115;
        RAM_data[10'd32] <= 32'd32;
        RAM_data[10'd33] <= 32'd110;
        RAM_data[10'd34] <= 32'd111;
        RAM_data[10'd35] <= 32'd116;
        RAM_data[10'd36] <= 32'd32;
        RAM_data[10'd37] <= 32'd117;
        RAM_data[10'd38] <= 32'd110;
        RAM_data[10'd39] <= 32'd105;
        RAM_data[10'd40] <= 32'd120;
        RAM_data[10'd41] <= 32'd10;
        RAM_data[10'd42] <= 32'd117;
        RAM_data[10'd43] <= 32'd110;
        RAM_data[10'd44] <= 32'd105;
        RAM_data[10'd45] <= 32'd120;
        RAM_data[10'd46] <= 32'd10;
    end

    assign o_mem_read_data = i_mem_read? RAM_data[i_address]: 32'h00000000;
    
    integer i;
    always @(posedge clk)
        if (i_mem_write) begin
            RAM_data[i_address] <= i_mem_write_data;
        end
    
endmodule
