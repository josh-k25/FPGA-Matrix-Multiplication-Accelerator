`timescale 1ns/1ps

module accelerator5x5_tb;

localparam int N = 5;
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

    $display("5x5 TB started");

    clk = 0;
    reset = 1;
    start = 0;

    matrixA = '0;
    matrixB = '0;

    @(posedge clk);
    @(posedge clk);
    #1;
    reset = 0;

    //matrix A
    matrixA[0][0] = 8'd1;
    matrixA[0][1] = 8'd2;
    matrixA[0][2] = 8'd3;
    matrixA[0][3] = 8'd4;
    matrixA[0][4] = 8'd5;

    matrixA[1][0] = 8'd6;
    matrixA[1][1] = 8'd7;
    matrixA[1][2] = 8'd8;
    matrixA[1][3] = 8'd9;
    matrixA[1][4] = 8'd10;

    matrixA[2][0] = 8'd11;
    matrixA[2][1] = 8'd12;
    matrixA[2][2] = 8'd13;
    matrixA[2][3] = 8'd14;
    matrixA[2][4] = 8'd15;

    matrixA[3][0] = 8'd16;
    matrixA[3][1] = 8'd17;
    matrixA[3][2] = 8'd18;
    matrixA[3][3] = 8'd19;
    matrixA[3][4] = 8'd20;

    matrixA[4][0] = 8'd21;
    matrixA[4][1] = 8'd22;
    matrixA[4][2] = 8'd23;
    matrixA[4][3] = 8'd24;
    matrixA[4][4] = 8'd25;

    //matrix B
    matrixB[0][0] = 8'd1;
    matrixB[0][1] = 8'd2;
    matrixB[0][2] = 8'd3;
    matrixB[0][3] = 8'd4;
    matrixB[0][4] = 8'd5;

    matrixB[1][0] = 8'd6;
    matrixB[1][1] = 8'd7;
    matrixB[1][2] = 8'd8;
    matrixB[1][3] = 8'd9;
    matrixB[1][4] = 8'd10;

    matrixB[2][0] = 8'd11;
    matrixB[2][1] = 8'd12;
    matrixB[2][2] = 8'd13;
    matrixB[2][3] = 8'd14;
    matrixB[2][4] = 8'd15;

    matrixB[3][0] = 8'd16;
    matrixB[3][1] = 8'd17;
    matrixB[3][2] = 8'd18;
    matrixB[3][3] = 8'd19;
    matrixB[3][4] = 8'd20;

    matrixB[4][0] = 8'd21;
    matrixB[4][1] = 8'd22;
    matrixB[4][2] = 8'd23;
    matrixB[4][3] = 8'd24;
    matrixB[4][4] = 8'd25;

    start = 1;

    @(posedge clk);
    #1;
    start = 0;

    wait(done);

    if (result[0][0] !== 19'd215)  $fatal(1, "result[0][0] failed.");
    if (result[0][1] !== 19'd230)  $fatal(1, "result[0][1] failed.");
    if (result[0][2] !== 19'd245)  $fatal(1, "result[0][2] failed.");
    if (result[0][3] !== 19'd260)  $fatal(1, "result[0][3] failed.");
    if (result[0][4] !== 19'd275)  $fatal(1, "result[0][4] failed.");

    if (result[1][0] !== 19'd490)  $fatal(1, "result[1][0] failed.");
    if (result[1][1] !== 19'd530)  $fatal(1, "result[1][1] failed.");
    if (result[1][2] !== 19'd570)  $fatal(1, "result[1][2] failed.");
    if (result[1][3] !== 19'd610)  $fatal(1, "result[1][3] failed.");
    if (result[1][4] !== 19'd650)  $fatal(1, "result[1][4] failed.");

    if (result[2][0] !== 19'd765)  $fatal(1, "result[2][0] failed.");
    if (result[2][1] !== 19'd830)  $fatal(1, "result[2][1] failed.");
    if (result[2][2] !== 19'd895)  $fatal(1, "result[2][2] failed.");
    if (result[2][3] !== 19'd960)  $fatal(1, "result[2][3] failed.");
    if (result[2][4] !== 19'd1025) $fatal(1, "result[2][4] failed.");

    if (result[3][0] !== 19'd1040) $fatal(1, "result[3][0] failed.");
    if (result[3][1] !== 19'd1130) $fatal(1, "result[3][1] failed.");
    if (result[3][2] !== 19'd1220) $fatal(1, "result[3][2] failed.");
    if (result[3][3] !== 19'd1310) $fatal(1, "result[3][3] failed.");
    if (result[3][4] !== 19'd1400) $fatal(1, "result[3][4] failed.");

    if (result[4][0] !== 19'd1315) $fatal(1, "result[4][0] failed.");
    if (result[4][1] !== 19'd1430) $fatal(1, "result[4][1] failed.");
    if (result[4][2] !== 19'd1545) $fatal(1, "result[4][2] failed.");
    if (result[4][3] !== 19'd1660) $fatal(1, "result[4][3] failed.");
    if (result[4][4] !== 19'd1775) $fatal(1, "result[4][4] failed.");

    $display("All 5x5 accelerator tests passed.");
    $finish;

end

endmodule