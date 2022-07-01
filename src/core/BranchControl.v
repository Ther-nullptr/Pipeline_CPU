module BranchControl(i_relation,
                     i_branch,
                     o_branch);
    input [1:0] i_relation;
    input [2:0] i_branch;
    output reg o_branch;
    
    // 00:< 01:= 10:>
    always @(*) begin
        case(i_branch)
        3'b000:begin // no branch
            o_branch <= 0;
        end

        3'b001:begin // beq
            if(i_relation == 2'b01)begin
                o_branch<=1;
            end
            else begin
                o_branch<=0;
            end
        end

        3'b010:begin // bne
            if(i_relation != 2'b01)begin
                o_branch<=1;
            end
            else begin
                o_branch<=0;
            end
        end

        3'b011:begin // blez
            if(i_relation != 2'b10)begin
                o_branch<=1;
            end
            else begin
                o_branch<=0;
            end
        end

        3'b100:begin // bgtz
            if(i_relation == 2'b10)begin
                o_branch<=1;
            end
            else begin
                o_branch<=0;
            end
        end

        3'b101:begin // bltz
            if(i_relation == 2'b00)begin
                o_branch<=1;
            end
            else begin
                o_branch<=0;
            end
        end

        default:begin
            o_branch<=0;
        end
        
        endcase
    end
    
endmodule
