module PeripheralControl(reset,
                         clk,
                         i_address,
                         i_control_read,
                         i_control_write,
                         i_control_write_data,
                         o_control_read_data,
                         o_led,
                         o_digital);
    
    parameter LED_ADDRESS             = 32'h4000000C;
    parameter DIGITAL_ADDRESS         = 32'h40000010;
    parameter SYS_CLK_COUNTER_ADDRESS = 32'h40000014;
    
    input reset,clk;
    input i_control_read;
    input i_control_write;
    input [31:0] i_address;
    input [31:0] i_control_write_data;
    
    output [31:0] o_control_read_data;
    output [31:0] o_led;
    output [31:0] o_digital;
    
    wire [31:0] w_led;
    wire [31:0] w_digital;
    wire [31:0] w_clk;
    
    assign o_control_read_data = (~i_control_read)?32'b0:
                                 (i_address == LED_ADDRESS)?{24'b0, w_led[7:0]}:
                                 (i_address == DIGITAL_ADDRESS)?{20'b0, w_digital[7:0]}:
                                 (i_address == SYS_CLK_COUNTER_ADDRESS)?w_clk:
                                 32'b0;
    
    assign w_led = (i_control_write && i_address == LED_ADDRESS)?{24'b0, i_control_write_data[7:0]}:w_led;
    assign w_digital = (i_control_write && i_address == DIGITAL_ADDRESS)?{20'b0, i_control_write_data[11:0]}:w_digital;
    assign w_clk = (i_control_write && i_address == SYS_CLK_COUNTER_ADDRESS)?i_control_write_data:w_clk;
       
endmodule
