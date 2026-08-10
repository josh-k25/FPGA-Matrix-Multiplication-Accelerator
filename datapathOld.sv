module datapathOld(
    input logic clk,
    input logic reset,
    input logic start,

    output logic done,
    output logic [31:0] result
);

// Internal control singals 
logic lastAddress;
logic addressEnable;
logic addressReset;
logic accumulatorEnable;
logic accumulatorClear;
logic writeEnable;

// Internal data signal
logic [31:0] writeData;
assign writeData = address >> 2;
logic [31:0] readData;

//Internal address signal
logic [31:0] address;


dataMemory dataMemory(
    .clk(clk),
    .writeEnable(writeEnable),
    .writeData(writeData),
    .address(address),
    .readData(readData)
);

addressCounter addressCounter(
    .clk(clk),
    .reset(reset),
    .addressEnable(addressEnable),
    .addressReset(addressReset),
    .lastAddress(lastAddress),
    .address(address)
);

accumulator accumulator(
    .clk(clk),
    .accumulatorClear(accumulatorClear),
    .accumulatorEnable(accumulatorEnable),
    .reset(reset),
    .data(readData),
    .sum(result)
);

controller controller(
    .clk(clk),
    .reset(reset),
    .start(start),
    .lastAddress(lastAddress),
    .addressEnable(addressEnable),
    .addressReset(addressReset),
    .accumulatorEnable(accumulatorEnable),
    .accumulatorClear(accumulatorClear),
    .writeEnable(writeEnable),
    .done(done)
);

endmodule