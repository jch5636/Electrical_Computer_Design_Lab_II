`timescale 1ns / 1ps

module tb_d_flip_flop();

reg clk, D;
wire Q;

d_flip_flop FF(clk, D, Q);

initial begin
    clk <= 0;
    #30 D <= 0;
    #30 D <= 1;
    #30 D <= 0;
    #30 D <= 1;
    #30 D <= 0;
    #30 D <= 1;
    #30 D <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule