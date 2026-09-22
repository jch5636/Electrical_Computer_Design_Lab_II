module d_flip_flop(clk, D, Q);

input D, clk;
output reg Q;

always @(posedge clk)
begin
    Q <= D;
end

endmodule