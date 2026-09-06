module half_adder(a, b, c, s);

    input a, b;
    output c, s;
    wire c, s;

    assign c = a & b;
    assign s = (~a & b) | (a & ~b);

endmodule