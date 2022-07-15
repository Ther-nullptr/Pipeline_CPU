`timescale 1ns / 1ps
module DataMemory(clk,
                  i_address,
                  i_mem_write_data,
                  i_mem_write,
                  i_mem_read,
                  o_mem_read_data);
    
    input clk;
    input i_mem_write;
    input i_mem_read;
    input [8:0] i_address;
    input [31:0] i_mem_write_data;
    output reg [31:0] o_mem_read_data;
    
    wire [31:0] w_mem_read_data;

    initial begin 
        o_mem_read_data <= 0;
    end
    
    dist_mem_gen_data u_dist_mem_gen_data(
    .a(i_address),
    .d(i_mem_write_data),
    .clk(clk),
    .we(i_mem_write),
    .spo(w_mem_read_data)
    );
    
    always @(*) begin
        if (i_mem_read)begin
            o_mem_read_data <= w_mem_read_data;
        end
        else begin
            o_mem_read_data <= 0;
        end
    end
    
endmodule
