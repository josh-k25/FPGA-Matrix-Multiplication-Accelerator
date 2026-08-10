module RAMC(
    input logic clk,
    input logic writeEnable,
    input logic [3:0] address,
    input logic [31:0] dataIn,

    output logic [31:0] dataOut
);

logic [31:0] ramC [0:15];

always_ff @(posedge clk) begin
    if (writeEnable)
        memory[ramC[3:0]] <= dataIn;

    else 
        dataOut <= dataOut[address[3:0]];

endmodule