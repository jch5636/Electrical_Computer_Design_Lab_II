`timescale 1ns / 1ps

module tb_pre_A;

reg rst, clk;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

pre_A uut(
    .rst(rst),
    .clk(clk),
    .LCD_E(LCD_E),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW),
    .LCD_DATA(LCD_DATA),
    .LED_out(LED_out)
);

initial begin
    clk = 0;
    forever #500000 clk = ~clk;
end

initial begin
    rst = 0;
    #2000000;
    rst = 1;
    #700000000;
    $finish;
end

initial begin
    $monitor("time = %0d ns, state = %b", $time, uut.state);
end

endmodule