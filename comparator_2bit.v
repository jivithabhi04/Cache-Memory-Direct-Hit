module comparator_2bit (
    input  wire [1:0] A,        // incoming tag from address addr[3:2]
    input  wire [1:0] B,        // stored tag from tag directory (via MUX)
    input  wire       enable,   // controlled by FSM (start_compare signal)
    output wire       eq        // 1 = HIT, 0 = MISS (when enable=1)
);
    wire xnor0, xnor1;          // each is 1 if corresponding bits are equal
    wire and_out;               // 1 only if BOTH bits match

    xnor g_xnor0 (xnor0, A[0], B[0]);
    xnor g_xnor1 (xnor1, A[1], B[1]);
    and  g_and   (and_out, xnor0, xnor1);
    and  g_enable (eq, and_out, enable);

endmodule