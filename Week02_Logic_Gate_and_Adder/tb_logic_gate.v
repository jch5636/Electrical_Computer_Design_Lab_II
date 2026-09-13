`timescale 1ns / 1ps

module tb_logic_gate;

    reg a, b;
    wire x, y, z, u, v;

    logic_gate dut (
        .a(a),
        .b(b),
        .x(x),
        .y(y),
        .z(z),
        .u(u),
        .v(v)
    );

    initial begin
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;
    end

endmodule