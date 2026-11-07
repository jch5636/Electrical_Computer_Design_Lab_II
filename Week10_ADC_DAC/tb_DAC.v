`timescale 1ns / 1ps

module tb_DAC;

reg clk, rst;
reg [5:0] btn;
reg add_sel;

wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
wire [7:0] dac_d, led_out;

integer errors;

DAC UUT(clk, rst, btn, add_sel,
        dac_csn, dac_ldacn, dac_wrn, dac_a_b,
        dac_d, led_out);

always #500 clk = ~clk;

task press_button;
    input [5:0] button_value;
    input [7:0] expected;

    begin
        @(negedge clk);
        btn = button_value;

        repeat(20) @(negedge clk);
        btn = 6'b000000;

        repeat(400) @(negedge clk);

        if(UUT.dac_d_temp !== expected || dac_d !== expected) begin
            errors = errors + 1;
            $display("FAIL btn=%b temp=%d dac=%d expected=%d",
                     button_value, UUT.dac_d_temp, dac_d, expected);
        end
        else begin
            $display("PASS btn=%b temp=%d dac=%d",
                     button_value, UUT.dac_d_temp, dac_d);
        end
    end
endtask

initial begin
    clk = 0;
    rst = 0;
    btn = 6'b000000;
    add_sel = 0;
    errors = 0;

    #2000;
    rst = 1;

    #400000;

    // 9번 버튼으로 초기 비교값을 8로 설정
    press_button(6'b000001, 8'd8);

    // 각 버튼의 증감 동작 확인
    press_button(6'b100000, 8'd7); // 1번: 8 -> 7
    press_button(6'b010000, 8'd8); // 3번: 7 -> 8
    press_button(6'b001000, 8'd6); // 4번: 8 -> 6
    press_button(6'b000100, 8'd8); // 6번: 6 -> 8
    press_button(6'b000010, 8'd0); // 7번: 8 -> 0
    press_button(6'b000001, 8'd8); // 9번: 0 -> 8

    // 8비트 범위를 벗어났을 때의 동작 확인
    press_button(6'b000010, 8'd0);
    press_button(6'b100000, 8'd255);
    press_button(6'b010000, 8'd0);

    // B 출력 선택 확인
    @(negedge clk);
    add_sel = 1;

    repeat(2) @(negedge clk);

    if(dac_a_b !== 1'b1)
        errors = errors + 1;

    $display("TOTAL_ERRORS=%0d", errors);
    $finish;
end

endmodule