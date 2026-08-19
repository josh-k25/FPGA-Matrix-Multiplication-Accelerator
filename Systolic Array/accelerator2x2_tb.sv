`timescale 1ns/1ps

module accelerator2x2_tb;

localparam int N = 2;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic start;

logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;

logic done;
logic [N-1:0][N-1:0][sum_width-1:0] result;

accelerator #(
    .N(N),
    .sum_width(sum_width)
) dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .matrixA(matrixA),
    .matrixB(matrixB),
    .done(done),
    .result(result)
);

always #5 clk = ~clk;

initial begin

    $display("2x2 TB started");

    clk = 0;
    reset = 1;
    start = 0;

    matrixA = '0;
    matrixB = '0;

    @(posedge clk);
    #1;
    reset = 0;

    matrixA[0][0] = 8'd1;
    matrixA[0][1] = 8'd2;
    matrixA[1][0] = 8'd3;
    matrixA[1][1] = 8'd4;

    matrixB[0][0] = 8'd5;
    matrixB[0][1] = 8'd6;
    matrixB[1][0] = 8'd7;
    matrixB[1][1] = 8'd8;

    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    wait(done);

    if (result[0][0] !== 17'd19)
        $fatal(1, "result[0][0] failed.");

    if (result[0][1] !== 17'd22)
        $fatal(1, "result[0][1] failed.");

    if (result[1][0] !== 17'd43)
        $fatal(1, "result[1][0] failed.");

    if (result[1][1] !== 17'd50)
        $fatal(1, "result[1][1] failed.");

    $display("All 2x2 accelerator tests passed.");
    $finish;

end

endmodule