`timescale 1ns / 1ps

module DAC_display(clk, rst, btn, add_sel,
                   dac_csn, dac_ldacn, dac_wrn, dac_a_b,
                   dac_d, led_out, seg_data, seg_sel,
                   LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst;
input [5:0] btn;
input add_sel;

output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d, led_out;
output reg [7:0] seg_data, seg_sel;
output LCD_E;
output reg LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

reg [7:0] dac_d_temp;
reg [7:0] cnt;
reg [5:0] btn_t, btn_reg;
reg [1:0] state;

parameter DELAY   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;

reg [11:0] state_bcd;
reg [3:0] bcd;

reg [9:0] div_cnt;
reg clk_lcd;

reg [7:0] lcd_cnt;
reg [11:0] display_bcd;
reg [2:0] lcd_state;

parameter LCD_DELAY        = 3'b000,
          LCD_FUNCTION_SET = 3'b001,
          LCD_DISP_ONOFF   = 3'b010,
          LCD_ENTRY_MODE   = 3'b011,
          LCD_CLEAR_DISP   = 3'b100,
          LCD_LINE1        = 3'b101,
          LCD_DELAY_T      = 3'b110;

// 원샷 트리거
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        btn_reg <= 6'b000000;
        btn_t <= 6'b000000;
    end
    else begin
        btn_reg <= btn;
        btn_t <= btn & ~btn_reg;
    end
end

// DAC 상태 변경
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY;
    end
    else begin
        case(state)
            DELAY   : if(cnt == 200) state <= SET_WRN;
            SET_WRN : if(cnt == 50) state <= UP_DATA;
            UP_DATA : if(cnt == 30) state <= DELAY;
        endcase
    end
end

// DAC 상태별 카운터
always @(posedge clk or negedge rst) begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else begin
        case(state)
            DELAY :
                if(cnt >= 200) cnt <= 0;
                else cnt <= cnt + 1;

            SET_WRN :
                if(cnt >= 50) cnt <= 0;
                else cnt <= cnt + 1;

            UP_DATA :
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
        endcase
    end
end

// DAC 쓰기 신호 및 데이터 출력
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_wrn <= 1;
    end
    else begin
        case(state)
            DELAY :
                dac_wrn <= 1;

            SET_WRN :
                dac_wrn <= 0;

            UP_DATA :
                dac_d <= dac_d_temp;
        endcase
    end
end

// 버튼 입력에 따른 디지털 값 증감
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn_t == 6'b100000)
            dac_d_temp <= dac_d_temp - 8'b0000_0001;
        else if(btn_t == 6'b010000)
            dac_d_temp <= dac_d_temp + 8'b0000_0001;
        else if(btn_t == 6'b001000)
            dac_d_temp <= dac_d_temp - 8'b0000_0010;
        else if(btn_t == 6'b000100)
            dac_d_temp <= dac_d_temp + 8'b0000_0010;
        else if(btn_t == 6'b000010)
            dac_d_temp <= dac_d_temp - 8'b0000_1000;
        else if(btn_t == 6'b000001)
            dac_d_temp <= dac_d_temp + 8'b0000_1000;

        led_out <= dac_d_temp;
    end
end

// DAC 제어 신호 및 출력 선택
always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel; // 0 : select A, 1 : select B
end

// 1MHz 입력 클럭을 LCD용 500Hz 클럭으로 분주
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        div_cnt <= 0;
        clk_lcd <= 0;
    end
    else begin
        if(div_cnt >= 999) begin
            div_cnt <= 0;
            clk_lcd <= ~clk_lcd;
        end
        else div_cnt <= div_cnt + 1;
    end
end

// 8비트 DAC 데이터를 세 자리 BCD로 변환
always @(posedge clk or negedge rst) begin
    if(!rst)
        state_bcd <= 12'b0000_0000_0000;
    else begin
        state_bcd[11:8] <= dac_d / 100;
        state_bcd[7:4] <= (dac_d / 10) % 10;
        state_bcd[3:0] <= dac_d % 10;
    end
end

// 7-segment 자리 선택
always @(posedge clk or negedge rst) begin
    if(!rst)
        seg_sel <= 8'b11111110;
    else
        seg_sel <= {seg_sel[6:0], seg_sel[7]};
end

// S0이 가장 왼쪽, S7이 가장 오른쪽
// S5, S6, S7에 각각 백, 십, 일의 자리 표시
always @(*) begin
    case(seg_sel)
        8'b11011111 : bcd = state_bcd[11:8];
        8'b10111111 : bcd = state_bcd[7:4];
        8'b01111111 : bcd = state_bcd[3:0];
        default : bcd = 4'b1111;
    endcase
end

// seg_data[7:0] = {A, B, C, D, E, F, G, DP}
always @(*) begin
    case(bcd)
        0 : seg_data = 8'b11111100;
        1 : seg_data = 8'b01100000;
        2 : seg_data = 8'b11011010;
        3 : seg_data = 8'b11110010;
        4 : seg_data = 8'b01100110;
        5 : seg_data = 8'b10110110;
        6 : seg_data = 8'b10111110;
        7 : seg_data = 8'b11100000;
        8 : seg_data = 8'b11111110;
        9 : seg_data = 8'b11110110;
        default : seg_data = 8'b00000000;
    endcase
end

// LCD 상태 변경
always @(posedge clk_lcd or negedge rst) begin
    if(!rst) begin
        lcd_state <= LCD_DELAY;
    end
    else begin
        case(lcd_state)
            LCD_DELAY :
                if(lcd_cnt == 70)
                    lcd_state <= LCD_FUNCTION_SET;

            LCD_FUNCTION_SET :
                if(lcd_cnt == 30)
                    lcd_state <= LCD_DISP_ONOFF;

            LCD_DISP_ONOFF :
                if(lcd_cnt == 30)
                    lcd_state <= LCD_ENTRY_MODE;

            LCD_ENTRY_MODE :
                if(lcd_cnt == 30)
                    lcd_state <= LCD_CLEAR_DISP;

            LCD_CLEAR_DISP :
                if(lcd_cnt == 5)
                    lcd_state <= LCD_LINE1;

            LCD_LINE1 :
                if(lcd_cnt == 20)
                    lcd_state <= LCD_DELAY_T;

            LCD_DELAY_T :
                if(lcd_cnt == 5)
                    lcd_state <= LCD_LINE1;

            default :
                lcd_state <= LCD_DELAY;
        endcase
    end
end

// LCD 상태별 카운터
always @(posedge clk_lcd or negedge rst) begin
    if(!rst)
        lcd_cnt <= 0;
    else begin
        case(lcd_state)
            LCD_DELAY :
                if(lcd_cnt >= 70) lcd_cnt <= 0;
                else lcd_cnt <= lcd_cnt + 1;

            LCD_FUNCTION_SET, LCD_DISP_ONOFF, LCD_ENTRY_MODE :
                if(lcd_cnt >= 30) lcd_cnt <= 0;
                else lcd_cnt <= lcd_cnt + 1;

            LCD_CLEAR_DISP, LCD_DELAY_T :
                if(lcd_cnt >= 5) lcd_cnt <= 0;
                else lcd_cnt <= lcd_cnt + 1;

            LCD_LINE1 :
                if(lcd_cnt >= 20) lcd_cnt <= 0;
                else lcd_cnt <= lcd_cnt + 1;

            default :
                lcd_cnt <= 0;
        endcase
    end
end

// 한 줄을 출력하는 동안 표시할 숫자 유지
always @(posedge clk_lcd or negedge rst) begin
    if(!rst)
        display_bcd <= 12'b0000_0000_0000;
    else if(lcd_state == LCD_LINE1 && lcd_cnt == 0)
        display_bcd <= state_bcd;
end

// LCD 명령어 및 문자 출력
always @(posedge clk_lcd or negedge rst) begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
    else begin
        case(lcd_state)
            LCD_FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0011_1000;

            LCD_DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;

            LCD_ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0110;

            LCD_CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0001;

            LCD_LINE1 : begin
                case(lcd_cnt)
                    00 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b0_0_1000_0000;

                    01 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b1_0_0100_0100; // D

                    02 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b1_0_0100_0001; // A

                    03 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b1_0_0100_0011; // C

                    04 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b1_0_0011_1010; // :

                    05 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b1_0_0010_0000; // 공백

                    06 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= {2'b10, 4'b0011, display_bcd[11:8]};

                    07 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= {2'b10, 4'b0011, display_bcd[7:4]};

                    08 :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= {2'b10, 4'b0011, display_bcd[3:0]};

                    default :
                        {LCD_RS, LCD_RW, LCD_DATA}
                            <= 10'b1_0_0010_0000;
                endcase
            end

            default :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
        endcase
    end
end

assign LCD_E = (rst && lcd_state != LCD_DELAY) ? clk_lcd : 1'b0;

endmodule