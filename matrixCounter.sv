module matrixCounter(
    input logic clk,
    input logic clear,
    input logic reset,
    input logic countEnable,

    output logic [1:0] count 
);

always_ff(@posedge clk or @posedge reset)