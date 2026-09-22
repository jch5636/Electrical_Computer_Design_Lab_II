`timescale 1ns / 1ps

module tb_t_flip_flop();

reg clk, rst, T;
wire Q;

t_flip_flop FF(clk, rst, T, Q);

initial begin
    clk <= 0;
    rst <= 1;
    T <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
    #80 T <= 1;
    #100 T <= 0;
    #100 T <= 1;
    #100 T <= 0;
    #100 T <= 1;
    #100 T <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule