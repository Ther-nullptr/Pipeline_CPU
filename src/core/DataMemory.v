`timescale 1ns / 1ps
module DataMemory(reset,
                  clk,
                  i_address,
                  i_mem_write_data,
                  i_mem_read,
                  i_mem_write,
                  o_mem_read_data);
    input reset, clk;
    input i_mem_read, i_mem_write;
    input [31:0] i_address, i_mem_write_data;
    output [31:0] o_mem_read_data;
    
    parameter RAM_SIZE     = 256;
    parameter RAM_SIZE_BIT = 8;
    
    reg [31:0] RAM_data[RAM_SIZE - 1: 0];
    assign o_mem_read_data = i_mem_read? RAM_data[i_address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
    
    integer i;
    always @(posedge reset or posedge clk)
        if (reset)
            for (i = 0; i < RAM_SIZE; i = i + 1)
                RAM_data[i] <= 32'h00000000;
                else if (i_mem_write)
                RAM_data[i_address[RAM_SIZE_BIT + 1:2]] <= i_mem_write_data;
    
endmodule
