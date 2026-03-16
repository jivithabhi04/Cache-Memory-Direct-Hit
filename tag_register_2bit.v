module tag_register_2bit (
    input  wire       clk,
    input  wire       rst,
    input  wire       write_en,   // load_tag signal from FSM
    input  wire [1:0] d_in,       // tag to write (addr[3:2])
    output reg  [1:0] d_out       // stored tag value
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            d_out <= 2'b00;
        else if (write_en)
            d_out <= d_in;
        // If write_en is 0, d_out holds its old value 
    end

endmodule