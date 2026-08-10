module RAMC(
    input logic clk,
    input logic writeEnable,
    input logic [3:0] address,
    input logic [17:0] dataIn,

    output logic [17:0] dataOut
);

logic [31:0] ramC [0:15];

always_ff @(posedge clk) begin
    if (writeEnable)
        ramC[address] <= dataIn;

    else 
        dataOut <= dataOut[address[3:0]];

endmodule