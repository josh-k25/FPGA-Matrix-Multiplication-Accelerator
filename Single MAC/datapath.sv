module datapath#(
    parameter int N = 4,
    parameter int SUM_WIDTH = 16 + $clog2(N)
    )(
    input logic clk,
    input logic reset,
    input logic start,

    output logic done,
    output logic [SUM_WIDTH - 1:0] result
);

//controller signals
logic lastCol;
logic lastRow;
logic lastK;

logic accumulatorEnable;
logic accumulatorClear;
logic rowCount;
logic rowClear;
logic colCount;
logic colClear;
logic kCount;
logic kClear;
logic CWriteEnable;

localparam int INDEX_WIDTH = $clog2(N);
localparam int ADDR_WIDTH  = $clog2(N*N);

//RAM signals
logic [ADDR_WIDTH-1:0] addressA;
logic [ADDR_WIDTH-1:0] addressB;
logic [ADDR_WIDTH-1:0] addressC;

logic [7:0] dataA;
logic [7:0] dataB;

logic [SUM_WIDTH-1:0] dataInC;
logic [SUM_WIDTH-1:0] dataOutC;

//i matrixCounter
logic [INDEX_WIDTH-1:0] i;

//j matrixCounter
logic [INDEX_WIDTH-1:0] j;

//k matrixCounter
logic [INDEX_WIDTH-1:0] k;

//multiplier
logic [15:0] product;

//accumulator
logic [SUM_WIDTH-1:0] sum;
controller controller(
    .clk(clk),
    .reset(reset),
    .start(start),
    .lastCol(lastCol),
    .lastRow(lastRow),
    .lastK(lastK),
    .accumulatorEnable(accumulatorEnable),
    .accumulatorClear(accumulatorClear),
    .rowCount(rowCount),
    .rowClear(rowClear),
    .colCount(colCount),
    .colClear(colClear),
    .kCount(kCount),
    .kClear(kClear),
    .CWriteEnable(CWriteEnable),
    .done(done)
);

RAMA #(
    .N(N)
    ) RAMA(
    .address(addressA),
    .dataOut(dataA)
);

RAMB #(
    .N(N)
    ) RAMB (
    .address(addressB),
    .dataOut(dataB)
);

RAMC #(
    .N(N),
    .SUM_WIDTH(SUM_WIDTH)
    ) RAMC(
    .clk(clk),
    .writeEnable(CWriteEnable),
    .address(addressC),
    .dataIn(dataInC),
    .dataOut(dataOutC)
);

matrixCounter #(
    .N(N)
) iCounter(
    .clk(clk),
    .clear(rowClear),
    .reset(reset),
    .countEnable(rowCount),
    .count(i),
    .lastCount(lastRow)
);

matrixCounter #(
    .N(N)
) jCounter(
    .clk(clk),
    .clear(colClear),
    .reset(reset),
    .countEnable(colCount),
    .count(j),
    .lastCount(lastCol)
);

matrixCounter #(
    .N(N)
) kCounter(
    .clk(clk),
    .clear(kClear),
    .reset(reset),
    .countEnable(kCount),
    .count(k),
    .lastCount(lastK)
);

multiplier multiplier(
    .dataA(dataA),
    .dataB(dataB),
    .result(product)
);

accumulator #(
    .N(N),
    .WIDTH(SUM_WIDTH)
    ) accumulator (
    .clk(clk),
    .accumulatorClear(accumulatorClear),
    .accumulatorEnable(accumulatorEnable),
    .reset(reset),
    .product(product),
    .sum(sum)
);

assign addressA = (i * N) + k;
assign addressB = (k * N) + j;
assign addressC = (i * N) + j;

assign dataInC = sum;
assign result = dataOutC;

endmodule