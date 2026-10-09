`timescale 1us / 1ns

module tb_segment_array();

reg clk, rst;
reg btn;
wire [7:0] seg_data;
wire [7:0] seg_sel;
wire [3:0] state_bin;
wire [7:0] state_bcd;
wire [3:0] bcd;

segment_array S1(clk, rst, btn, seg_data, seg_sel);

assign state_bin = S1.state_bin;
assign state_bcd = S1.state_bcd;
assign bcd = S1.bcd;

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 0;
    #10; rst <= 0;
    #10; rst <= 1;
    repeat(16) begin
        #10; btn <= 1;
        #10; btn <= 0;
    end
    #10; $finish;
end

always begin
    #0.5 clk <= ~clk;
end

endmodule