module datapath(
    input logic clk,
    input logic reset,
    input logic start,

    output logic done,
    output logic [17:0] result
);

