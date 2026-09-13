`timescale 1ns / 1ps

module tb_mux_8_to_1;

    reg [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
    reg S0, S1, S2;
    wire [3:0] Y;

    mux_8_to_1 uut(I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2, Y);

    initial begin
        I0 = 4'b0001;
        I1 = 4'b0010;
        I2 = 4'b0011;
        I3 = 4'b0100;
        I4 = 4'b0101;
        I5 = 4'b0110;
        I6 = 4'b0111;
        I7 = 4'b1000;

        {S2, S1, S0} = 3'b000; #10;
        {S2, S1, S0} = 3'b001; #10;
        {S2, S1, S0} = 3'b010; #10;
        {S2, S1, S0} = 3'b011; #10;
        {S2, S1, S0} = 3'b100; #10;
        {S2, S1, S0} = 3'b101; #10;
        {S2, S1, S0} = 3'b110; #10;
        {S2, S1, S0} = 3'b111; #10;

        $finish;
    end

endmodule
