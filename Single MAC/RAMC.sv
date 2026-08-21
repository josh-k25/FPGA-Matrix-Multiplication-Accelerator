module RAMC#(
    parameter int N = 4,
    parameter int SUM_WIDTH = 16 + $clog2(N),
    parameter int ADDR_WIDTH = $clog2(N*N)
)(
    input logic clk,
    input logic writeEnable,
    input logic [ADDR_WIDTH-1:0] address,
    input logic [SUM_WIDTH-1:0] dataIn,

    output logic [SUM_WIDTH-1:0] dataOut
);

logic [17:0] ramC [0:N*N - 1];

always_ff @(posedge clk) begin
    if (writeEnable)
        ramC[address] <= dataIn;
end

assign dataOut = ramC[address];

endmodule