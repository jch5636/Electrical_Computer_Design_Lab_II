`timescale 1ns / 1ps

module tb_jk_flip_flop();

reg clk, J, K;
wire Q;

jk_flip_flop FF(clk, J, K, Q);

initial begin
    clk <= 0;
    {J, K} <= 2'b00;
    #100 {J, K} <= 2'b01;
    #100 {J, K} <= 2'b00;
    #100 {J, K} <= 2'b10;
    #100 {J, K} <= 2'b00;
    #100 {J, K} <= 2'b11;
    #100 {J, K} <= 2'b00;
end

always begin
    #5 clk <= ~clk;
end

endmodule