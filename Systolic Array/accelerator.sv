module accelerator #(
    parameter int N = 8,
    /*number of calculations in each cell is = # of columns in matrix a or the number of rows im matrix b
    so 16 + clog2(# of columns in a) should be sufficcient for bit width assumign 8 bit elements
    */
    parameter int sum_width = 16 + $clog2(N)
)(
    input logic clk,
    input logic reset,
    input logic start,

    input logic [N-1:0][N-1:0][7:0] matrixA,
    input logic [N-1:0][N-1:0][7:0] matrixB,

    //true dimensions of the matrices as they come in
    //number of rows in matrix A
    input logic [N-1:0] M,
    //number of columns in A and number of rows in B
    input logic [N-1:0] K,
    //number of coluumns in matrix b
    input logic [N-1:0] P,

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

    .M(M),
    .K(K),
    .P(P),

    .lastK(lastK),
    .lastDrain(lastDrain),

    .result(result)
);

endmodule