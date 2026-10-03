`timescale 1ns / 1ps

module tb_state_machine;

    reg clk, rst, x;
    wire [1:0] state;
    wire y;

    state_machine uut(clk, rst, x, y, state);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 0;
        x = 0;
        #12 rst = 1;

        #8 x = 1;       // 4.1.1: 00, x=1 -> 01, y=0
        #10 x = 0;      // 4.1.2: 01, x=0 -> 00, y=1
        #10 x = 1;      // 00 -> 01
        #10 x = 1;      // 4.1.3: 01, x=1 -> 11, y=0
        #10 x = 1;      // 11 -> 10
        #10 x = 0;      // 4.1.4: 10, x=0 -> 00, y=1
        #10 x = 1;      // 00 -> 01
        #10 x = 1;      // 01 -> 11
        #10 x = 1;      // 11 -> 10
        #10 x = 1;      // 4.1.5: 10, x=1 -> 10, y=0

        #10 rst = 0;
        x = 0;
        #12 rst = 1;
        #8 x = 1;       // 00 -> 01
        #10 x = 1;      // 01 -> 11
        #10 x = 0;      // 4.1.6: 11, x=0 -> 00, y=1

        #20 $finish;
    end
endmodule