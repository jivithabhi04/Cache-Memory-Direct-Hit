module cache_controller (
    input  wire clk,
    input  wire rst,
    input  wire read_req,       // CPU requesting a read
    input  wire hit_miss,       // result from datapath comparator

    output reg  load_tag,       // tell datapath to store tag (for future use)
    output reg  start_compare,  // tell comparator to activate
    output reg  hit_out,        // assert when hit detected
    output reg  miss_out        // assert when miss detected
);

    parameter IDLE    = 2'b00;
    parameter COMPARE = 2'b01;
    parameter HIT     = 2'b10;
    parameter MISS    = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:    next_state = read_req ? COMPARE : IDLE;
            COMPARE: next_state = hit_miss ? HIT     : MISS;
            HIT:     next_state = IDLE;    
            MISS:    next_state = IDLE;    
            default: next_state = IDLE;
        endcase
    end

    
    
    always @(*) begin
        load_tag      = 0;
        start_compare = 0;
        hit_out       = 0;
        miss_out      = 0;

        case (current_state)
            IDLE: begin
                // Nothing to do; waiting for read_req
                // load_tag could optionally be set here on a write, but
                // this project is read-only, so nothing is asserted
            end

            COMPARE: begin
                // Enable the comparator: tell datapath to evaluate hit/miss
                start_compare = 1;
                // Also latch the current tag into the directory if not already
                // stored (simple version: always store on any access)
                load_tag = 1;
            end

            HIT: begin
                // Tell the outside world: "this was a hit"
                hit_out = 1;
            end

            MISS: begin
                // Tell the outside world: "this was a miss"
                miss_out = 1;
            end
        endcase
    end

endmodule
