`timescale 1ns / 1ps
module cache_tb;
 
    reg        clk;
    reg        rst;
    reg  [3:0] addr;
    reg        read_req;
    wire       hit_out;
    wire       miss_out;
 
    // connect to top module
    cache_top uut (
        .clk      (clk),
        .rst      (rst),
        .addr     (addr),
        .read_req (read_req),
        .hit_out  (hit_out),
        .miss_out (miss_out)
    );
 
    // clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;
 
    initial begin
 
        // apply reset
        rst = 1;  read_req = 0;  addr = 4'b0000;
        #20;       // 2 clock cycles of reset
        rst = 0;
        #10;       // 1 idle cycle before first test
 
        $display("Test | addr | tag | blk | hit | miss | result");
        $display("-----|------|-----|-----|-----|------|-------");
 
        // TEST 1 — addr 1010 — tag=10  block=1
        // tag directory is 00 after reset, incoming tag is 10 ? MISS
        addr = 4'b1010;  read_req = 1;
        #10;  read_req = 0;   // cycle 1: FSM IDLE ? COMPARE
        #10;                  // cycle 2: FSM COMPARE ? MISS   ? result is here
        $display("  1  | 1010 |  10 |  1  |  %b  |   %b  | %s", hit_out, miss_out, miss_out?"MISS":"HIT");
        #10;                  // cycle 3: FSM back to IDLE
 
        // TEST 2 — addr 1010 again — tag=10  block=1
        // tag 10 was stored in block 1 during test 1 ? HIT
        addr = 4'b1010;  read_req = 1;
        #10;  read_req = 0;
        #10;
        $display("  2  | 1010 |  10 |  1  |  %b  |   %b  | %s", hit_out, miss_out, hit_out?"HIT":"MISS");
        #10;
 
        // TEST 3 — addr 0110 — tag=01  block=1
        // block 1 holds tag 10, but incoming tag is 01 ? MISS
        addr = 4'b0110;  read_req = 1;
        #10;  read_req = 0;
        #10;
        $display("  3  | 0110 |  01 |  1  |  %b  |   %b  | %s", hit_out, miss_out, miss_out?"MISS":"HIT");
        #10;
 
        // TEST 4 — addr 0100 — tag=01  block=0
        // block 0 was never written (cold), stored tag is 00 ? MISS
        addr = 4'b0100;  read_req = 1;
        #10;  read_req = 0;
        #10;
        $display("  4  | 0100 |  01 |  0  |  %b  |   %b  | %s", hit_out, miss_out, miss_out?"MISS":"HIT");
        #10;
 
        // TEST 5 — addr 0100 again — tag=01  block=0
        // tag 01 was stored in block 0 during test 4 ? HIT
        addr = 4'b0100;  read_req = 1;
        #10;  read_req = 0;
        #10;
        $display("  5  | 0100 |  01 |  0  |  %b  |   %b  | %s", hit_out, miss_out, hit_out?"HIT":"MISS");
        #10;
 
        $display("--- simulation done ---");
        $finish;
 
    end
 
endmodule