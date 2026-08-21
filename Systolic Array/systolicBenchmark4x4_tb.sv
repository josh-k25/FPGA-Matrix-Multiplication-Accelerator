`timescale 1ns/1ps

module systolicBenchmark4x4_tb;

localparam int N = 4;
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
    //  1   2   3   4
    //  5   6   7   8
    //  9  10  11  12
    // 13  14  15  16

    //packed-array concatenation is written in reverse index order
    matrixA = {
        8'd16, 8'd15, 8'd14, 8'd13,
        8'd12, 8'd11, 8'd10, 8'd9,
        8'd8,  8'd7,  8'd6,  8'd5,
        8'd4,  8'd3,  8'd2,  8'd1
    };


    //Matrix B
    // 16  15  14  13
    // 12  11  10   9
    //  8   7   6   5
    //  4   3   2   1

    matrixB = {
        8'd1,  8'd2,  8'd3,  8'd4,
        8'd5,  8'd6,  8'd7,  8'd8,
        8'd9,  8'd10, 8'd11, 8'd12,
        8'd13, 8'd14, 8'd15, 8'd16
    };


    //hold reset for two rising edges
    @(posedge clk);
    #1;

    @(posedge clk);
    #1;

    reset = 0;


    //assert start
    start = 1;

    //this edge accepts start
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
            "Systolic 4x4 timed out after %0d cycles",
            cycles
        );


    //expected C = A * B
    //  80   70   60   50
    // 240  214  188  162
    // 400  358  316  274
    // 560  502  444  386

    checkResult(result[0][0], 0, 0, 80);
    checkResult(result[0][1], 0, 1, 70);
    checkResult(result[0][2], 0, 2, 60);
    checkResult(result[0][3], 0, 3, 50);

    checkResult(result[1][0], 1, 0, 240);
    checkResult(result[1][1], 1, 1, 214);
    checkResult(result[1][2], 1, 2, 188);
    checkResult(result[1][3], 1, 3, 162);

    checkResult(result[2][0], 2, 0, 400);
    checkResult(result[2][1], 2, 1, 358);
    checkResult(result[2][2], 2, 2, 316);
    checkResult(result[2][3], 2, 3, 274);

    checkResult(result[3][0], 3, 0, 560);
    checkResult(result[3][1], 3, 1, 502);
    checkResult(result[3][2], 3, 2, 444);
    checkResult(result[3][3], 3, 3, 386);   


    $display("Systolic 4x4 matrix multiplication passed.");
    $display("Systolic 4x4 cycles: %0d", cycles);

    $finish;

end

endmodule