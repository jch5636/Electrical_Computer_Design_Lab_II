module logic_gate(a, b, x, y, z, u, v);

input a, b;

output x, y, z, u, v;

wire x, y, z, u, v;

assign x = a & b;

assign y = a | b;

assign z = a ^ b;

assign u = ~(a | b);

assign v = ~(a & b);

endmodule