`timescale 1ns / 1ps

module tb_LED3_control;

    reg clk, rst;
    reg [7:0] btn;

    wire [3:0] led_signal_R;
    wire [3:0] led_signal_G;
    wire [3:0] led_signal_B;

    wire [7:0] reference_R;
    wire [7:0] reference_G;
    wire [7:0] reference_B;

    wire R;
    wire G;
    wire B;

    LED3_control uut(
        clk, rst, btn,
        led_signal_R, led_signal_G, led_signal_B
    );

    assign reference_R = uut.state[23:16];
    assign reference_G = uut.state[15:8];
    assign reference_B = uut.state[7:0];

    assign R = led_signal_R[0];
    assign G = led_signal_G[0];
    assign B = led_signal_B[0];

    always #500 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btn = 8'b00000000;

        #2000 rst = 0;

        // 빨간색
        #1000 btn = 8'b00000001;

        // 주황색
        #1024000 btn = 8'b00000010;

        // 노란색
        #1024000 btn = 8'b00000100;

        #1024000 $finish;
    end

endmodule