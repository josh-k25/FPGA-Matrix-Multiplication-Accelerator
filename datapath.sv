module datapath(
    input logic clk,
    input logic reset,
    input logic start,

    output logic done,
    output logic [17:0] result
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

//ROM signals
logic [3:0] addressA;
logic [3:0] addressB;
logic [3:0] addressC;
logic [7:0] dataA;
logic [7:0] dataB;
logic [17:0] dataInC;
logic [17:0] dataOutC;

//i matrixCounter 
logic [2:0] i;

//j matrixCounter 
logic [2:0] j;

//k matrixCounter
logic [2:0] k;

logic [15:0] product;

//accumulator
logic [17:0] sum;

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

ROMA ROMA(
    .address(addressA),
    .dataOut(dataA)
);

ROMB ROMB(
    .address(addressB),
    .dataOut(dataB)
);

RAMC RAMC(
    .clk(clk),
    .writeEnable(CWriteEnable),
    .address(addressC),
    .dataIn(dataInC),
    .dataOut(dataOutC)
);

matrixCounter iCounter(
    .clk(clk),
    .clear(rowClear),
    .reset(reset),
    .countEnable(rowCount),
    .count(i),
    .lastCount(lastRow)
);

matrixCounter jCounter(
    .clk(clk),
    .clear(colClear),
    .reset(reset),
    .countEnable(colCount),
    .count(j),
    .lastCount(lastCol)
);

matrixCounter kCounter(
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

accumulator accumulator(
    .clk(clk),
    .accumulatorClear(accumulatorClear),
    .accumulatorEnable(accumulatorEnable),
    .reset(reset),
    .product(product),
    .sum(sum)
);

assign addressA = (i * 4) + k;
assign addressB = (k * 4) + j;
assign addressC = (i * 4) + j;

assign dataInC = sum;
assign result = dataOutC;

endmodule