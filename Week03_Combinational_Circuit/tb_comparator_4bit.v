`timescale 1ns / 1ps

module tb_comparator_4bit;

    reg [3:0] a, b;
    wire x, y, z;

    comparator_4bit uut(a, b, x, y, z);

    initial begin
        // 6.2.1
        a = 4'b0011; b = 4'b1000; #10;

        // 6.2.2
        a = 4'b0111; b = 4'b0001; #10;

        // 6.2.3
        a = 4'b1001; b = 4'b1001; #10;

        // 6.2.4
        a = 4'b1011; b = 4'b1111; #10;

        $finish;
    end

endmodule