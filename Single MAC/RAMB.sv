module RAMB #(
    parameter int N = 4,
    parameter int ADDR_WIDTH = $clog2(N*N)
)(
    input logic [ADDR_WIDTH-1:0] address,

    output logic [7:0] dataOut
);

logic [7:0] ramB [0:N*N-1];

initial begin
    for (int i = 0; i < N*N; i = i + 1) begin
        ramB[i] = i + 1;
    end
end

assign dataOut = ramB[address];

endmodule