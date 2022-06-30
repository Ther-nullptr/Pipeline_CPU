module ImmediateExtension(i_extop,
                          i_luiop,
                          i_immediate,
                          o_imm_ext,
                          o_imm_ext_shift);
    
    //Input Control Signals
    input i_extop; //'0'-zero extension, '1'-signed extension
    input i_luiop; //for lui instruction
    
    //Input Data
    input [15:0] i_immediate;
    
    //Output Data
    output [31:0] o_imm_ext;
    output [31:0] o_imm_ext_shift;
    
    wire [31:0] w_imm_ext;
    
    assign w_imm_ext       = {i_extop? {16{i_immediate[15]}}: 16'h0000, i_immediate};
    assign o_imm_ext_shift = w_imm_ext << 2;
    assign o_imm_ext       = i_luiop? {i_immediate, 16'h0000}: w_imm_ext;
    
endmodule
