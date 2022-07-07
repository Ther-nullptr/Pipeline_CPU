module SysClkCounter(reset,
                     clk,
                     o_count);
    input reset,clk;
    output reg [31:0] o_count;

    parameter CLKS_IN_1MS = 10000; // 100MHz
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_count <= 32'h0;
        end
        else if(o_count <= CLKS_IN_1MS*4) begin
            o_count <= o_count + 1;
        end
        else begin
            o_count <= 32'h0;
        end
    end
    
endmodule
