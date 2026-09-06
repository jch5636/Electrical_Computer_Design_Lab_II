module full_adder(a, b, cin, c, s);

    input a, b, cin;
    output c, s;
    wire c, s;
    wire s1, c1, c2;

    half_adder u1(a, b, c1, s1);
    half_adder u2(s1, cin, c2, s);

    assign c = c1 | c2;

endmodule