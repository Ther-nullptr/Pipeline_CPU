`timescale 1ns / 1ps
module DataMemory(clk,
                  i_address,
                  i_mem_write_data,
                  i_mem_write,
                  o_mem_read_data);
    
    input clk;
    input i_mem_write;
    input [8:0] i_address;
    input [31:0] i_mem_write_data;
    output [31:0] o_mem_read_data;
    
    dist_mem_gen_data u_dist_mem_gen_data(
    .a(i_address),
    .d(i_mem_write_data),
    .clk(clk),
    .we(i_mem_write),
    .spo(o_mem_read_data)
    );
    
endmodule
