module accelerator #(
    parameter int N = 4,
    parameter int sum_width = 16 + $clog2(N)
)(
    input logic clk,
    input logic reset,
    input logic start,

    input logic [N-1:0][N-1:0][7:0] matrixA,
    input logic [N-1:0][N-1:0][7:0] matrixB,

    output logic done,
    output logic [N-1:0][N-1:0][sum_width-1:0] result
);

//controller -> datapath control signals
logic clear;
logic feedValid;
logic kCount;
logic kClear;
logic drainCount;
logic drainClear;

//datapath -> controller status signals
logic lastK;
logic lastDrain;

systolicController #(
    .N(N)
) controller_inst (
    .clk(clk),
    .reset(reset),
    .start(start),

    .lastK(lastK),
    .lastDrain(lastDrain),

    .clear(clear),
    .feedValid(feedValid),
    .kCount(kCount),
    .kClear(kClear),
    .drainCount(drainCount),
    .drainClear(drainClear),
    .done(done)
);

systolicDatapath #(
    .N(N),
    .sum_width(sum_width)
) datapath_inst (
    .clk(clk),
    .reset(reset),

    .clear(clear),
    .feedValid(feedValid),
    .kCount(kCount),
    .kClear(kClear),
    .drainCount(drainCount),
    .drainClear(drainClear),

    .matrixA(matrixA),
    .matrixB(matrixB),

    .lastK(lastK),
    .lastDrain(lastDrain),

    .result(result)
);

endmodule