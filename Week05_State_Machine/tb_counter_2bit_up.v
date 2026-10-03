`timescale 1ns / 1ps

module tb_counter_2bit_up;

    reg clk, rst, x;
    wire [1:0] state;

    counter_2bit_up uut(clk, rst, x, state);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 0;
        x = 0;
        #12 rst = 1;
        #8;

        repeat(8) begin
            x = 1;
            #30;
            x = 0;
            #30;
        end

        #20 $finish;
    end
endmodule