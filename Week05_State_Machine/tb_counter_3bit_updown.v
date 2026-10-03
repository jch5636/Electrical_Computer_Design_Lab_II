`timescale 1ns / 1ps

module tb_counter_3bit_updown;

    reg clk, rst, x;
    wire [2:0] state;

    counter_3bit_updown uut(clk, rst, x, state);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 0;
        x = 0;
        #12 rst = 1;
        #8;

        repeat(17) begin
            x = 1;
            #30;
            x = 0;
            #30;
        end

        #20 $finish;
    end
endmodule