module half_adder_case(a, b, c, s);

    input a, b;
    output c, s;
    reg c, s;

    always @(*) begin
        case ({a, b})
            2'b00: {c, s} = 2'b00;
            2'b01: {c, s} = 2'b01;
            2'b10: {c, s} = 2'b01;
            2'b11: {c, s} = 2'b10;
            default: {c, s} = 2'b00;
        endcase
    end

endmodule