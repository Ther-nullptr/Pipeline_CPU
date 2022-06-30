module Hazard(
    i_ID_EX_mem_read,
    i_ID_EX_Rd,
    i_IF_ID_Rs,
    i_IF_ID_Rt,
    o_IF_flush
);
    input i_ID_EX_mem_read;
    input i_ID_EX_Rd;
    input i_IF_ID_Rs;
    input i_IF_ID_Rt;
    output o_IF_flush;

    // TODO how many kinds of hazard?

endmodule