`timescale 1ns / 1ps

module InstructionMemory(i_address,
                         o_instruction);
    
    input [8:0] i_address;
    output [31:0] o_instruction;
    
    dist_mem_gen_instruction u_dist_mem_gen_instruction (
    .a(i_address),
    .spo(o_instruction)
    );
    
endmodule