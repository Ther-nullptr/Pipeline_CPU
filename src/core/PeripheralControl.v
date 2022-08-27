`timescale 1ns / 1ps
module PeripheralControl(reset,
                         clk,
                         i_address,
                         i_control_read,
                         i_control_write,
                         i_control_write_data,
                         i_uart_rxd,
                         i_uart_txd,
                         i_uart_con,
                         o_control_read_data,
                         o_led,
                         o_digital
                         );
    
    parameter LED_ADDRESS             = 32'h4000000C;
    parameter DIGITAL_ADDRESS         = 32'h40000010;
    parameter SYS_CLK_COUNTER_ADDRESS = 32'h40000014;
    parameter UART_TXD_ADDRESS        = 32'h40000018;
    parameter UART_RXD_ADDRESS        = 32'h4000001C;
    parameter UART_CON_ADDRESS        = 32'h40000020;
    parameter CLKS_IN_1MS = 32'd10000; // 100MHz
    
    input reset,clk;
    input i_control_read;
    input i_control_write;
    input [31:0] i_address;
    input [31:0] i_control_write_data;

    input [7:0] i_uart_rxd;
    input [7:0] i_uart_txd;
    input [2:0] i_uart_con;
    
    output [31:0] o_control_read_data;
    output [31:0] o_led;
    output [31:0] o_digital;
    
    reg [31:0] r_led;
    reg [31:0] r_digital;
    reg [31:0] r_clk;
    
    initial begin
        r_led     <= 32'b0;
        r_digital <= 32'b0;
        r_clk     <= 32'b0;
    end
    
    assign o_control_read_data = reset?32'b0:
    (~i_control_read)?32'b0:
    (i_address == LED_ADDRESS)?{24'b0, r_led[7:0]}:
    (i_address == DIGITAL_ADDRESS)?{20'b0, r_digital[7:0]}:
    (i_address == SYS_CLK_COUNTER_ADDRESS)?r_clk:
    (i_address == UART_TXD_ADDRESS)?i_uart_txd:
    (i_address == UART_RXD_ADDRESS)?i_uart_rxd:
    (i_address == UART_CON_ADDRESS)?i_uart_con:
    32'b0;
    
    always @(*) begin
        if(i_control_write && i_address == LED_ADDRESS)begin
            r_led <= {24'b0, i_control_write_data[7:0]};
        end
        else begin
            r_led <= r_led;
        end

        if(i_control_write && i_address == DIGITAL_ADDRESS)begin
            r_digital <= {20'b0, i_control_write_data[11:0]};
        end
        else begin
            r_digital <= r_digital;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_clk <= 32'h0;
        end
        else if(r_clk <= CLKS_IN_1MS*4) begin
            r_clk <= r_clk + 1;
        end
        else begin
            r_clk <= 32'h0;
        end
    end
    
    assign o_led     = reset?0:r_led;
    assign o_digital = reset?0:r_digital;
    
endmodule
