`timescale 1ns/1ps

module acceleratorRandom_tb;

localparam int N = 2;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic start;

//normal packed arrays
logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;

logic done;
logic [N-1:0][N-1:0][sum_width-1:0] result;

//unpacked arrays to accomodate for icarus limitations
logic [7:0] matrixA_u [0:N-1][0:N-1];
logic [7:0] matrixB_u [0:N-1][0:N-1];

logic [sum_width-1:0] expected [0:N-1][0:N-1];
wire  [sum_width-1:0] result_u [0:N-1][0:N-1];

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

//generate unpacked arrays from packed arrays
generate
    for (r = 0; r < N; r = r + 1) begin
        for (c = 0; c < N; c = c + 1) begin
            assign matrixA[r][c] = matrixA_u[r][c];
            assign matrixB[r][c] = matrixB_u[r][c];
            assign result_u[r][c] = result[r][c];
        end
    end
endgenerate

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;

    //reset accelerator
    @(posedge clk);
    @(posedge clk);

    @(negedge clk);
    reset = 0;

    for (int test = 0; test < 20; test++) begin

    wait (done == 1'b0);

    //assign rand values to unpacked
    for (int row = 0; row < N; row = row + 1) begin
        for (int col = 0; col < N; col = col + 1) begin
            matrixA_u[row][col] = $urandom_range(255, 0);
            matrixB_u[row][col] = $urandom_range(255, 0);
        end
    end

    //calculate expected
    for (int row = 0; row < N; row = row + 1) begin
        for (int col = 0; col < N; col = col + 1) begin
            expected[row][col] = '0;
            for (int k = 0; k < N; k = k + 1) begin
                expected[row][col] = expected[row][col] + matrixA_u[row][k] * matrixB_u[k][col];
            end
        end
    end

    //start accelerator
    @(negedge clk);
    start = 1;

    @(negedge clk);
    start = 0;


    //wait for result
    wait(done == 1'b1);
    #1;

    //compare C vs expected
    for (int row = 0; row < N; row = row + 1) begin
        for (int col = 0; col < N; col = col + 1) begin
            if (result_u[row][col] !== expected[row][col]) begin
                $fatal(1, "Test %0d failed at [%0d][%0d]: expected %0d, got %0d", test, row, col, expected[row][col], result_u[row][col]
                );
            end
        end
    end

    $display("Random test %0d passed.", test + 1);
    end
    
    $display("All 20 random tests passed.");
    $finish;

end

endmodule