`timescale 1ns / 1ps
module CPU_tb;

    reg clk;
    reg reset;

    wire [7:0] led;
    wire [11:0] bcd7;

    parameter PERIOD = 10;

    CPU U_CPU(
        .reset(reset),
        .clk(clk),
        .real_digital(bcd7),
        .real_led(led)
    );

    initial begin
        clk = 0;
        reset = 1;
        #(PERIOD * 10) reset = 0;
        #(PERIOD * 30000) $finish;
    end

    initial begin
        forever begin
            #(PERIOD / 2) clk = ~clk;
        end
    end

endmodule