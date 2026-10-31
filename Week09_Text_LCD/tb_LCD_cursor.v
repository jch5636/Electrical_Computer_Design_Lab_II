`timescale 1ns / 1ps

module tb_LCD_cursor;

reg rst, clk;
reg [9:0] number_btn;
reg [1:0] control_btn;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

LCD_cursor uut(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);

always #500 clk = ~clk;

initial begin
    rst = 0;
    clk = 0;
    number_btn = 10'b0000_0000_00;
    control_btn = 2'b00;

    #2000 rst = 1;
    #400000;

    number_btn = 10'b0100_0000_00; // 2
    #100000;
    number_btn = 10'b0000_0000_00;
    #100000;

    number_btn = 10'b0000_0000_10; // 9
    #100000;
    number_btn = 10'b0000_0000_00;
    #100000;

    control_btn = 2'b10; // left
    #100000;
    control_btn = 2'b00;
    #100000;

    control_btn = 2'b01; // right
    #100000;
    control_btn = 2'b00;
    #100000;

    $finish;
end

always @(negedge LCD_E) begin
    if(rst && (LCD_RS || LCD_DATA == 8'b0001_0000 || LCD_DATA == 8'b0001_0100))
        $display("time=%0t state=%0d RS=%b RW=%b DATA=%b",
                 $time, uut.state, LCD_RS, LCD_RW, LCD_DATA);
end

endmodule