module systolicArrayNxN #(
    parameter int N = 4,
    parameter int sum_width = 16 + $clog2(N)
    )(
    input logic clk,
    input logic reset,
    input logic clear,

    input logic [N-1:0][7:0] dataInA,
    input logic [N-1:0][7:0] dataInB,

    input logic [N-1:0] AValidIn,
    input logic [N-1:0] BValidIn,

    output logic [N-1:0][N-1:0][sum_width-1:0] sum
);

logic [7:0] A_link [0:N-1][0:N];
logic [7:0] B_link [0:N][0:N-1];

logic AValid_link [0:N-1][0:N];
logic BValid_link [0:N][0:N-1];

genvar r;
genvar c;

generate
    for (r = 0; r < N; r = r + 1) begin
        assign A_link[r][0] = dataInA[r];
        assign AValid_link[r][0] = AValidIn[r];
    end

    for (c = 0; c < N; c = c + 1) begin
        assign B_link[0][c] = dataInB[c];
        assign BValid_link[0][c] = BValidIn[c];
    end

    for (r = 0; r < N; r = r + 1) begin : rows
        for (c = 0; c < N; c = c + 1) begin : cols
            processingElement #(
                .sum_width(sum_width)
            ) PE (
                .clk(clk),
                .clear(clear),
                .reset(reset),
                .dataInA(A_link[r][c]),
                .dataInB(B_link[r][c]),
                .AValidIn(AValid_link[r][c]),
                .BValidIn(BValid_link[r][c]),
                .dataOutA(A_link[r][c + 1]),
                .dataOutB(B_link[r + 1][c]),
                .AValidOut(AValid_link[r][c + 1]),
                .BValidOut(BValid_link[r + 1][c]),
                .sum(sum[r][c])
            );
        end
    end
        
endgenerate

endmodule