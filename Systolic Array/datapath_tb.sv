`timescale 1ns/1ps

module datapath_tb;

localparam int N = 4;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic clear;
logic feedValid;
logic kCount;
logic kClear;
logic drainCount;
logic drainClear;
logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;

logic lastK;
logic lastDrain;
logic [N-1:0][N-1:0][sum_width-1:0] result;

datapath #(
    .N(N),
    .sum_width(sum_width)
) dut (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .feedValid(feedValid),
    .kCount(kCount),
    .kClear(kClear),
    .drainCount(drainCount),
    .drainClear(drainClear),
    .matrixA(matrixA),
    .matrixB(matrixB),
    .lastK(lastK),
    .lastDrain(lastDrain),
    .result(result)
);

always #5 clk = ~clk;

initial begin
    clk = '0;
    reset = 1'b1;
    clear = 1'b0;
    feedValid = 1'b0;
    kCount = 1'b0;
    kClear = 1'b0;
    drainCount = 1'b0;
    drainClear = 1'b0;
    matrixA = '0;
    matrixB = '0;
    
    @(posedge clk);
    #1;

    reset = 1'b0;

    matrixA = {
        8'd16, 8'd15, 8'd14, 8'd13,
        8'd12, 8'd11, 8'd10, 8'd9,
        8'd8, 8'd7, 8'd6, 8'd5,
        8'd4, 8'd3, 8'd2, 8'd1
    };

    matrixB = {
        8'd16, 8'd15, 8'd14, 8'd13,
        8'd12, 8'd11, 8'd10, 8'd9,
        8'd8, 8'd7, 8'd6, 8'd5,
        8'd4, 8'd3, 8'd2, 8'd1
    };

    clear = 1'b1;
    kClear = 1'b1;
    drainClear = 1'b1;

    @(posedge clk);
    #1;

    clear = 1'b0;
    kClear = 1'b0;
    drainClear = 1'b0;

    feedValid = 1'b1;
    kCount = 1'b1;

    //k = 0
    @(posedge clk);
    #1;

    //k = 1
    @(posedge clk);
    #1;

    //k = 2
    @(posedge clk);
    #1;

    if (lastK !== 1'b1)
    $fatal(1, "lastK failed.");

    kCount = 1'b0;

    @(posedge clk);
    #1;

    feedValid = 1'b0;
    drainCount = 1'b1;

    wait (lastDrain == 1'b1);
    drainCount = 1'b0;

if (result[0][0] !== 18'd90)
    $fatal(1, "result[0][0] failed.");

if (result[0][1] !== 18'd100)
    $fatal(1, "result[0][1] failed.");

if (result[0][2] !== 18'd110)
    $fatal(1, "result[0][2] failed.");

if (result[0][3] !== 18'd120)
    $fatal(1, "result[0][3] failed.");


if (result[1][0] !== 18'd202)
    $fatal(1, "result[1][0] failed.");

if (result[1][1] !== 18'd228)
    $fatal(1, "result[1][1] failed.");

if (result[1][2] !== 18'd254)
    $fatal(1, "result[1][2] failed.");

if (result[1][3] !== 18'd280)
    $fatal(1, "result[1][3] failed.");


if (result[2][0] !== 18'd314)
    $fatal(1, "result[2][0] failed.");

if (result[2][1] !== 18'd356)
    $fatal(1, "result[2][1] failed.");

if (result[2][2] !== 18'd398)
    $fatal(1, "result[2][2] failed.");

if (result[2][3] !== 18'd440)
    $fatal(1, "result[2][3] failed.");


if (result[3][0] !== 18'd426)
    $fatal(1, "result[3][0] failed.");

if (result[3][1] !== 18'd484)
    $fatal(1, "result[3][1] failed.");

if (result[3][2] !== 18'd542)
    $fatal(1, "result[3][2] failed.");

if (result[3][3] !== 18'd600)
    $fatal(1, "result[3][3] failed.");

$display("All datapath tests passed.");
$finish;

end
endmodule
