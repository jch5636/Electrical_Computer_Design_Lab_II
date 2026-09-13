`timescale 1ns / 1ps

module tb_priority_encoder_4_to_3;

    reg D0, D1, D2, D3;
    wire x, y, V;

    priority_encoder_4_to_3 uut(D0, D1, D2, D3, x, y, V);

    initial begin
        // 6.6.1
        {D3, D2, D1, D0} = 4'b0000; #10;

        // 6.6.2
        {D3, D2, D1, D0} = 4'b1000; #10;

        // 6.6.3
        {D3, D2, D1, D0} = 4'b1011; #10;

        // 6.6.4
        {D3, D2, D1, D0} = 4'b0101; #10;

        // 6.6.5
        {D3, D2, D1, D0} = 4'b0001; #10;

        $finish;
    end

endmodule