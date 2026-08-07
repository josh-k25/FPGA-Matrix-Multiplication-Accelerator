module RAMB(
    input logic clk,
    input logic writeEnable,
    input logic [7:0] writeData,
    input logic [7:0] address,

    output logic [7:0] readData
)

logic [7:0] ramB [0:15];

endmodule