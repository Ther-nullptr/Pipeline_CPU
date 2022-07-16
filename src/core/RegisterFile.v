`timescale 1ns / 1ps
module RegisterFile(reset,
                    clk,
                    i_reg_write,
                    i_read_register1,
                    i_read_register2,
                    i_write_register,
                    i_write_data,
                    o_read_data1,
                    o_read_data2);
    input reset, clk;
    input i_reg_write;
    input [4:0] i_read_register1, i_read_register2, i_write_register;
    input [31:0] i_write_data;
    output [31:0] o_read_data1, o_read_data2;
    
    reg [31:0] RF_data[31:1];
    
    assign o_read_data1 = (i_read_register1 == 5'b00000)? 32'h00000000: 
    (i_write_register == i_read_register1)?i_write_data:
    RF_data[i_read_register1];
    assign o_read_data2 = (i_read_register2 == 5'b00000)? 32'h00000000: 
    (i_write_register == i_read_register2)?i_write_data:
    RF_data[i_read_register2];
    
    integer i;
    always @(posedge reset or posedge clk) begin
		if (reset) begin
			for (i = 1; i < 32; i = i + 1) begin
				RF_data[i] <= 32'h00000000;
			end
		end else if (i_reg_write && (i_write_register != 5'b00000)) begin
			RF_data[i_write_register] <= i_write_data;
		end
	end
    
endmodule