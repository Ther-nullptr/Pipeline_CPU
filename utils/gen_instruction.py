print(
'''`timescale 1ns / 1ps
module InstructionMemory(i_address,
                         o_instruction);
    
    input [8:0] i_address;
    output [31:0] o_instruction;'''
    )

print(
'''always @(*)
        case (i_address[9:2])''')

with open('hex.txt') as f:
    for i,line in enumerate(f):
        print(f"9'd{i}:    o_instruction <= 32'h{line.strip()};")

print('''default: o_instruction <= 32'h00000000;
        endcase
endmodule''')