`timescale 1ns / 1ps

module tb_LED_control;

    reg clk, rst;
    reg [7:0] bin;

    wire [7:0] seg_data;
    wire [7:0] seg_sel;
    wire led_signal;

    integer on_time_us;
    integer off_time_us;
    integer on_count;

    LED_control uut(clk, rst, bin, seg_data, seg_sel, led_signal);

    always #500 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        bin = 8'd0;

        #2000 rst = 0;

        #1024000 bin = 8'd63;
        #1024000 bin = 8'd127;
        #1024000 bin = 8'd191;
        #1024000 bin = 8'd255;

        #1024000 $finish;
    end

    initial begin
        on_time_us = 0;
        off_time_us = 0;
        on_count = 0;

        wait(rst == 0);

        forever begin
            on_count = 0;

            repeat(256) begin
                @(posedge clk);
                #1;
                if(led_signal == 1'b1)
                    on_count = on_count + 1;
            end

            on_time_us = on_count;
            off_time_us = 256 - on_count;
        end
    end

endmodule