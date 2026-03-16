module mux2to1_1bit (
    input  wire in0,   // input when sel=0  (tag from block 0)
    input  wire in1,   // input when sel=1  (tag from block 1)
    input  wire sel,   // select line = addr[1] (block number)
    output wire out    // selected tag bit going to comparator
);
    
    wire not_sel;
    wire and0_out;
    wire and1_out;

    not  g_not  (not_sel,   sel);
    and  g_and0 (and0_out,  in0, not_sel);
    and  g_and1 (and1_out,  in1, sel);
    or   g_or   (out,       and0_out, and1_out);

endmodule