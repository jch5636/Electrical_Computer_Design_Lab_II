`timescale 1ns / 1ps

module mux_4_to_1(I0, I1, I2, I3, S0, S1, Y);

    input [1:0] I0, I1, I2, I3;
    input S0, S1;
    output reg [1:0] Y;

    always @(*)
    begin
        case ({S1, S0})
            2'b00: Y = I0;
            2'b01: Y = I1;
            2'b10: Y = I2;
            2'b11: Y = I3;
            default: Y = 2'b00;
        endcase
    end

endmodule