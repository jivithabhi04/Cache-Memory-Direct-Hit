module cache_datapath (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] addr,           // full 4-bit address
    input  wire       load_tag,       // control signal from FSM
    input  wire       start_compare,  // control signal from FSM
    output wire       hit_miss        // result
);


    wire [1:0] tag_in;         // addr[3:2] - incoming tag
    wire       block_sel;      // addr[1]   - selects cache block
    wire [1:0] stored_tag_0;   // tag stored in block 0
    wire [1:0] stored_tag_1;   // tag stored in block 1
    wire [1:0] mux_out;        // tag selected by MUX ? goes to comparator

    
    assign tag_in    = addr[3:2];   
    assign block_sel = addr[1];     

    wire write_en_0, write_en_1;
    wire not_block_sel;

    not  g_not_sel  (not_block_sel, block_sel);
    and  g_wen0     (write_en_0, load_tag, not_block_sel);  // write block 0
    and  g_wen1     (write_en_1, load_tag, block_sel);      // write block 1

    tag_register_2bit tag_dir_0 (
        .clk      (clk),
        .rst      (rst),
        .write_en (write_en_0),
        .d_in     (tag_in),
        .d_out    (stored_tag_0)
    );

    tag_register_2bit tag_dir_1 (
        .clk      (clk),
        .rst      (rst),
        .write_en (write_en_1),
        .d_in     (tag_in),
        .d_out    (stored_tag_1)
    );

    // Instantiate 2-bit MUX 
    
    mux2to1_2bit tag_mux (
        .in0 (stored_tag_0),
        .in1 (stored_tag_1),
        .sel (block_sel),
        .out (mux_out)
    );

    // Instantiate comparator 
    comparator_2bit tag_cmp (
        .A      (tag_in),
        .B      (mux_out),
        .enable (start_compare),
        .eq     (hit_miss)
    );

endmodule
