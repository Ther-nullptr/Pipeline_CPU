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
    
    reg output_clk;
    
    parameter DIVIDE = 100;
    reg [13:0] count;
    initial begin
        output_clk <= 0;
    end
    
    always @(posedge clk) begin
        if (count < DIVIDE/2 -1) begin
            count      <= count + 1;
            output_clk <= output_clk;
        end
        else begin
            count      <= 14'd0;
            output_clk <= ~output_clk;
        end
    end
    
    CPU U_CPU(
        .reset(reset),
        .clk(output_clk),
        .real_digital(real_digital),
        .real_led(real_led)
    );

endmodule