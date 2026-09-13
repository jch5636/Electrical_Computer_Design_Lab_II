`timescale 1ns / 1ps

module tb_decoder_3_to_8;

    reg x, y, z;
    wire [7:0] D;

decoder_3_to_8 uut(x, y, z, D);

    initial begin
        {x, y, z} = 3'b000; #10;
        {x, y, z} = 3'b001; #10;
        {x, y, z} = 3'b010; #10;
        {x, y, z} = 3'b011; #10;
        {x, y, z} = 3'b100; #10;
        {x, y, z} = 3'b101; #10;
        {x, y, z} = 3'b110; #10;
        {x, y, z} = 3'b111; #10;

        $finish;
    end

endmodule