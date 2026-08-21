`timescale 1ns/1ps

module systolicBenchmark2x2_tb;

localparam int N = 2;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic start;

logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;

logic done;
logic [N-1:0][N-1:0][sum_width-1:0] result;

integer cycles;

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


//checks result matrix
task checkResult;
    input logic [sum_width-1:0] actual;
    input integer row;
    input integer col;
    input integer expected;

    begin
        if (actual !== expected)
            $fatal(1,"C[%0d][%0d] failed: expected %0d, got %0d", row, col, expected, actual);
    end
endtask


initial begin

    clk = 0;
    reset = 1;
    start = 0;
    cycles = 0;

    matrixA = '0;
    matrixB = '0;


    //Matrix A
    // [1 2]
    // [3 4]

    matrixA[0][0] = 8'd1;
    matrixA[0][1] = 8'd2;
    matrixA[1][0] = 8'd3;
    matrixA[1][1] = 8'd4;


    //Matrix B
    // [4 3]
    // [2 1]

    matrixB[0][0] = 8'd4;
    matrixB[0][1] = 8'd3;
    matrixB[1][0] = 8'd2;
    matrixB[1][1] = 8'd1;


    //hold reset for two rising edges
    @(posedge clk);
    #1;

    @(posedge clk);
    #1;

    reset = 0;


    //assert start
    start = 1;

    @(posedge clk);
    #1;

    start = 0;


    cycles = 0;


    while ((done !== 1'b1) && (cycles < 1000)) begin
        @(posedge clk);
        #1;

        cycles = cycles + 1;
    end


    if (done !== 1'b1)
        $fatal(
            1,
            "Systolic 2x2 timed out after %0d cycles",
            cycles
        );


    //expected C = A * B
    // [ 8  5]
    // [20 13]

    checkResult(result[0][0], 0, 0, 8);
    checkResult(result[0][1], 0, 1, 5);
    checkResult(result[1][0], 1, 0, 20);
    checkResult(result[1][1], 1, 1, 13);


    $display("Systolic 2x2 matrix multiplication passed.");
    $display("Systolic 2x2 cycles: %0d", cycles);

    $finish;

end

endmodule