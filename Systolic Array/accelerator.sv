module accelerator #(
    parameter int rowsA = 8,
    parameter int columnsA = 4,
    parameter int rowsB = 4,
    parameter int columnsB = 8,
    /*number of calculations in each cell is = # of columns in matrix a or the number of rows im matrix b
    so 16 + clog2(# of columns in a) should be sufficcient for bit width assumign 8 bit elements
    */
    parameter int sum_width = 16 + $clog2(columnsA)
)(
    input logic clk,
    input logic reset,
    input logic start,

    input logic [rowsA-1:0][columnsA-1:0][7:0] matrixA,
    input logic [rowsB-1:0][columnsB-1:0][7:0] matrixB,

    output logic done,
    output logic [rowsA-1:0][columnsB-1:0][sum_width-1:0] result
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

systolicController systolicController(
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
) systolicDatapath (
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