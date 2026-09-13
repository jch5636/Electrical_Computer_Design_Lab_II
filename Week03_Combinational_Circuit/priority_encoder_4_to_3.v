`timescale 1ns / 1ps

module priority_encoder_4_to_3(D0, D1, D2, D3, x, y, V);

    input D0, D1, D2, D3;
    output x, y, V;
    wire x, y, V;

    assign x = D2 | D3;
    assign y = D3 | (D1 & (~D2));
    assign V = D0 | D1 | D2 | D3;

endmodule