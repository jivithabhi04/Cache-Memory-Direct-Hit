module mux2to1_2bit (
    input  wire [1:0] in0,   // 2-bit stored_tag from block 0
    input  wire [1:0] in1,   // 2-bit stored_tag from block 1
    input  wire       sel,   // addr[1] selects which block's tag to read
    output wire [1:0] out    // goes to comparator input B
);
    mux2to1_1bit mux_bit1 (.in0(in0[1]), .in1(in1[1]), .sel(sel), .out(out[1]));
    mux2to1_1bit mux_bit0 (.in0(in0[0]), .in1(in1[0]), .sel(sel), .out(out[0]));

endmodule 