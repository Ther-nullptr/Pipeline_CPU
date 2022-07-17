`timescale 1ns / 1ps
module BranchControl(i_data1,
                     i_data2,
                     i_branch,
                     o_branch);
    input signed [31:0] i_data1;
    input signed [31:0] i_data2;
    input [2:0] i_branch;
    output reg o_branch;
    
    wire [1:0] w_relation;
    assign w_relation = (i_data1 < i_data2)?2'b00:
    (i_data1 > i_data2)?2'b10:
    2'b01;
    
    // 00:< 01: = 10:>
    always @(*) begin
        case(i_branch)
            3'b000:begin // no branch
                o_branch <= 0;
            end
            
            3'b001:begin // beq
                case(w_relation)
                2'b01:begin
                    o_branch <= 1;
                end
                default:begin
                    o_branch <= 0;
                end
                endcase
            end
            
            3'b010:begin // bne
                case(w_relation)
                2'b01:begin
                    o_branch <= 0;
                end
                default:begin
                    o_branch <= 1;
                end
                endcase
            end
            
            3'b011:begin // blez
                if (i_data1 < 0 || i_data1 == 0)begin
                    o_branch <= 1;
                end
                else begin
                    o_branch <= 0;
                end
            end
            
            3'b100:begin // bgtz
                if (i_data1>0)begin
                    o_branch <= 1;
                end
                else begin
                    o_branch <= 0;
                end
            end
            
            3'b101:begin // bltz
                if (i_data1<0)begin
                    o_branch <= 1;
                end
                else begin
                    o_branch <= 0;
                end
            end
            
            default:begin
                o_branch <= 0;
            end
            
        endcase
    end
    
endmodule
