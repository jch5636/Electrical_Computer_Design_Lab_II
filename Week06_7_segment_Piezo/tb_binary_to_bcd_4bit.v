`timescale 1us / 1ns

module tb_binary_to_bcd_4bit();

reg clk, rst;
reg [3:0] bin;
wire [7:0] bcd;

binary_to_bcd_4bit B1(clk, rst, bin, bcd);

initial begin
    clk <= 0;
    rst <= 1;
    bin <= 4'b0000;
    #10; rst <= 0;
    #10; rst <= 1;
    #10; bin <= 4'd1;
    #10; bin <= 4'd2;
    #10; bin <= 4'd3;
    #10; bin <= 4'd4;
    #10; bin <= 4'd5;
    #10; bin <= 4'd6;
    #10; bin <= 4'd7;
    #10; bin <= 4'd8;
    #10; bin <= 4'd9;
    #10; bin <= 4'd10;
    #10; bin <= 4'd11;
    #10; bin <= 4'd12;
    #10; bin <= 4'd13;
    #10; bin <= 4'd14;
    #10; bin <= 4'd15;
    #10; $finish;
end

always begin
    #0.5 clk <= ~clk;
end

endmodule