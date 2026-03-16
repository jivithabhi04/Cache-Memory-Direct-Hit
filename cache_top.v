module cache_top (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] addr,       // 4-bit memory address from CPU
    input  wire       read_req,   // CPU read request
    output wire       hit_out,    // cache hit indicator
    output wire       miss_out    // cache miss indicator
);

    // Internal control wires between controller and datapath
    wire load_tag;
    wire start_compare;
    wire hit_miss;        // datapath ? controller: raw comparator output

    cache_controller ctrl (
        .clk           (clk),
        .rst           (rst),
        .read_req      (read_req),
        .hit_miss      (hit_miss),
        .load_tag      (load_tag),
        .start_compare (start_compare),
        .hit_out       (hit_out),
        .miss_out      (miss_out)
    );

    cache_datapath dp (
        .clk           (clk),
        .rst           (rst),
        .addr          (addr),
        .load_tag      (load_tag),
        .start_compare (start_compare),
        .hit_miss      (hit_miss)
    );

endmodule
