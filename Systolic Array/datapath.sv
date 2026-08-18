module datapath #(
    parameter int N = 4,
    parameter int sum_width = 16 + $clog2(N)
)(
    input logic clk,
    input logic reset,
    input logic clear,
    input logic feedValid,
    input logic kCount,
    input logic kClear,
    input logic drainCount,
    input logic drainClear,
    input logic [N-1:0][N-1:0][7:0] matrixA,
    input logic [N-1:0][N-1:0][7:0] matrixB,

    output logic lastK,
    output logic lastDrain,
    output logic [N-1:0][N-1:0][sum_width-1:0] result
);

//cycles needed to completely drain the pipeline
localparam int DRAIN_CYCLES = 2*N - 2;
localparam int DRAIN_WIDTH  = $clog2(DRAIN_CYCLES + 1);

logic [$clog2(N)-1:0] k;
logic [DRAIN_WIDTH-1:0] drain;

logic [N-1:0][7:0] rawA;
logic [N-1:0][7:0] rawB;

//workaround for icarus verilog issue. packed array for b was having issues
logic [7:0] matrixB_unpacked [0:N-1][0:N-1];

logic [N-1:0] rawAValid;
logic [N-1:0] rawBValid;

logic [N-1:0][7:0] skewedA;
logic [N-1:0][7:0] skewedB;

logic [N-1:0] skewedAValid;
logic [N-1:0] skewedBValid;

always_ff @(posedge clk) begin
    if (reset)
        k <= '0;
    else if (kClear)
        k <= '0;
    else if (kCount)
        k <= k + 1;
end

always_ff @(posedge clk) begin
    if (reset)
        drain <= '0;
    else if (drainClear)
        drain <= '0;
    else if (drainCount)
        drain <= drain + 1;
end

assign lastK = (k == N-1);
assign lastDrain = (drain == DRAIN_CYCLES);

dataSkewer #(
    .N(N)
) dataSkewer (
    .clk(clk),
    .reset(reset),

    .rawA(rawA),
    .rawB(rawB),

    .rawAValid(rawAValid),
    .rawBValid(rawBValid),

    .skewedA(skewedA),
    .skewedB(skewedB),

    .skewedAValid(skewedAValid),
    .skewedBValid(skewedBValid)
);

genvar row;
genvar col;
genvar bRow;
genvar bCol;

generate 
for (row = 0; row < N; row++)
    assign rawA[row] = matrixA[row][k];

    for (bRow = 0; bRow < N; bRow = bRow + 1) begin : gen_B_rows
        for (bCol = 0; bCol < N; bCol = bCol + 1) begin : gen_B_cols
            assign matrixB_unpacked[bRow][bCol] = matrixB[bRow][bCol];
        end
    end

    for (col = 0; col < N; col = col + 1) begin : gen_rawB
        assign rawB[col] = matrixB_unpacked[k][col];
    end
endgenerate


assign rawAValid = {N{feedValid}};
assign rawBValid = {N{feedValid}};

systolicArrayNxN #(
    .N(N),
    .sum_width(sum_width)
) systolicArrayNxN (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .dataInA(skewedA),
    .dataInB(skewedB),
    .AValidIn(skewedAValid),
    .BValidIn(skewedBValid),
    .sum(result)
);

endmodule