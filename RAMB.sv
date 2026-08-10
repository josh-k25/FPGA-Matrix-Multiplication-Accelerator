module RAMB(
    input logic clk,
    input logic writeEnable,
    input logic [3:0] address,
    input logic [7:0] dataIn,

    output logic [7:0] dataOut
);

logic [7:0] ramB [0:15];

always_ff @(posedge clk)
    if (writeEnable)
        ramB[address] <= dataIn;

dataOut = ramB[address];


endmodule