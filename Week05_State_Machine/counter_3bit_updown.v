`timescale 1ns / 1ps

module counter_3bit_updown(clk, rst, x, state);

    input clk, rst;
    input x;
    reg x_reg, x_trig;
    reg up;
    output reg [2:0] state;

    always @(negedge rst or posedge clk) begin
        if(!rst) begin
            {x_reg, x_trig} <= 2'b00;
        end
        else begin
            x_reg <= x;
            x_trig <= x & ~x_reg;
        end
    end

    always @(negedge rst or posedge clk) begin
        if(!rst) up <= 1'b1;
        else begin
            if(x_trig) begin
                case(state)
                    3'b000: up <= 1'b1;
                    3'b111: up <= 1'b0;
                endcase
            end
        end
    end

    always @(negedge rst or posedge clk) begin
        if(!rst) state <= 3'b000;
        else begin
            case(state)
                3'b000: state <= x_trig ? 3'b001 : 3'b000;

                3'b001: state <= x_trig ?
                                (up ? 3'b010 : 3'b000) : 3'b001;

                3'b010: state <= x_trig ?
                                (up ? 3'b011 : 3'b001) : 3'b010;

                3'b011: state <= x_trig ?
                                (up ? 3'b100 : 3'b010) : 3'b011;

                3'b100: state <= x_trig ?
                                (up ? 3'b101 : 3'b011) : 3'b100;

                3'b101: state <= x_trig ?
                                (up ? 3'b110 : 3'b100) : 3'b101;

                3'b110: state <= x_trig ?
                                (up ? 3'b111 : 3'b101) : 3'b110;

                3'b111: state <= x_trig ? 3'b110 : 3'b111;
            endcase
        end
    end
endmodule