`timescale 1us / 1ns

module tb_piezo_piano();

reg clk, rst;
reg [7:0] btn;
wire piezo;

piezo_piano P1(clk, rst, btn, piezo);

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 8'b00000000;
    #1e+6; rst <= 0;
    #1e+6; rst <= 1;
    #1e+6; btn <= 8'b00000010;
    #1e+6; btn <= 8'b00100000;
    #1e+6; $finish;
end

always begin
    #0.5 clk <= ~clk;
end

endmodule