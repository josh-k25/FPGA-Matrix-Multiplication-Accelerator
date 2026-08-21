module accumulator #(
    parameter int N = 4,
    parameter int WIDTH = 16 + $clog2(N)
    )(
    input logic clk,
    input logic accumulatorClear,
    input logic accumulatorEnable,
    input logic reset,
    input logic [15:0] product,

    output logic [WIDTH-1:0] sum
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        sum <= 18'd0;
    else if (accumulatorClear)
        sum <= 18'd0;
    else if (accumulatorEnable)
        sum <= sum + product;
end 

endmodule