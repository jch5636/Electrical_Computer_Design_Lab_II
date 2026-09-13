`timescale 1ns / 1ps

module comparator4(
    input wire [3:0] a, b,
    output wire gt, eq, lt
);

    assign gt = (a > b);
    assign eq = (a == b);
    assign lt = (a < b);

endmodule