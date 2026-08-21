`timescale 1ns/1ps

module systolicBenchmark_tb;

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

//icarus workaround
logic [sum_width-1:0] result_u [0:N-1][0:N-1];

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

genvar r;
genvar c;

generate
    for (r = 0; r < N; r = r + 1) begin : gen_result_rows
        for (c = 0; c < N; c = c + 1) begin : gen_result_cols
            assign result_u[r][c] = result[r][c];
        end
    end
endgenerate

always #5 clk = ~clk;

task checkResult;
    input integer row;
    input integer col;
    input integer expected;

    begin
        if (result_u[row][col] !== expected)
            $fatal(1, "C[%0d][%0d] failed: expected %0d, got %0d", row, col, expected, result_u[row][col]);
    end
endtask


initial begin

    clk = 0;
    reset = 1;
    start = 0;
    cycles = 0;

    matrixA = '0;
    matrixB = '0;


    //same Matrix A as CPU benchmark
    //packed-array assignment is reversed because of
    //the [N-1:0] packed dimensions
    matrixA = {
        8'd16, 8'd15, 8'd14, 8'd13,
        8'd12, 8'd11, 8'd10, 8'd9,
        8'd8,  8'd7,  8'd6,  8'd5,
        8'd4,  8'd3,  8'd2,  8'd1
    };


    //same Matrix B as CPU benchmark
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


    //start calculation
    start = 1;

    //accelerator accepts start here
    @(posedge clk);
    #1;

    start = 0;

    //matrix setup/reset is not included
    cycles = 0;


    while ((done !== 1'b1) && (cycles < 1000)) begin
        @(posedge clk);
        #1;

        cycles = cycles + 1;
    end


    if (done !== 1'b1)
        $fatal(
            1,
            "Systolic accelerator timed out after %0d cycles",
            cycles
        );


    //expected C
    checkResult(0, 0, 80);
    checkResult(0, 1, 70);
    checkResult(0, 2, 60);
    checkResult(0, 3, 50);

    checkResult(1, 0, 240);
    checkResult(1, 1, 214);
    checkResult(1, 2, 188);
    checkResult(1, 3, 162);

    checkResult(2, 0, 400);
    checkResult(2, 1, 358);
    checkResult(2, 2, 316);
    checkResult(2, 3, 274);

    checkResult(3, 0, 560);
    checkResult(3, 1, 502);
    checkResult(3, 2, 444);
    checkResult(3, 3, 386);


    $display("Systolic matrix multiplication passed.");
    $display("Systolic cycles: %0d", cycles);

    $finish;

end

endmodule