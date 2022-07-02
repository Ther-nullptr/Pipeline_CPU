module BCD7(in_data,
            out_code);
    
    input 	[3:0] in_data;
    output 	[6:0] out_code;
    
    wire [6:0] out_code;
    assign	out_code = (in_data == 4'h0)?7'b0111111:
    (in_data == 4'h1)?7'b0000110:
    (in_data == 4'h2)?7'b1011011:
    (in_data == 4'h3)?7'b1001111:
    (in_data == 4'h4)?7'b1100110:
    (in_data == 4'h5)?7'b1101101:
    (in_data == 4'h6)?7'b1111101:
    (in_data == 4'h7)?7'b0000111:
    (in_data == 4'h8)?7'b1111111:
    (in_data == 4'h9)?7'b1101111:
    (in_data == 4'ha)?7'b1110111:
    (in_data == 4'hb)?7'b1111100:
    (in_data == 4'hc)?7'b0111001:
    (in_data == 4'hd)?7'b1011110:
    (in_data == 4'he)?7'b1111001:
    (in_data == 4'hf)?7'b1110001:7'b0000000;
    
endmodule
    
