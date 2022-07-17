module CPU_on_board(
    reset,
    clk,
    real_led,
    real_digital
);
    input reset;
    input clk;
    output [11:0] real_digital;
    output [7:0] real_led;

    CPU U_CPU(
        .reset(reset),
        .clk(clk),
        .real_digital(real_digital),
        .real_led(real_led)
    );

endmodule