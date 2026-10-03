`timescale 1ns / 1ps

module tb_vending_machine;

    reg clk, rst;
    reg A, B, C;
    wire [2:0] state;
    wire y;

    vending_machine uut(clk, rst, A, B, C, state, y);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 0;
        {A,B,C} = 3'b000;
        #12 rst = 1;
        #8;

        A = 1; #30; A = 0; #30;  // S0 -> S50
        B = 1; #30; B = 0; #30;  // S50 -> S150
        A = 1; #30; A = 0; #30;  // S150 -> S200
        B = 1; #30; B = 0; #30;  // S200 -> S200
        C = 1; #30; C = 0; #30;  // S200 -> S0, y=1

        rst = 0;
        #12 rst = 1;
        #8;

        A = 1; #30; A = 0; #30;  // S0 -> S50
        B = 1; #30; B = 0; #30;  // S50 -> S150
        C = 1; #30; C = 0; #30;  // S150 -> S150, y=0

        #20 $finish;
    end
endmodule