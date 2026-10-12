`timescale 1ns/1ps

module systolicArrayMxP_tb;

localparam int N = 8;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic start;

logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;
logic [N-1:0] M;
logic [N-1:0] K;
logic [N-1:0] P;

logic done;
logic [N-1:0][N-1:0][sum_width-1:0] result;

//unpacked arrays used by the testbench checker (icarus verilog issue workaroud) 
logic [7:0] matrixA_tb [0:N-1][0:N-1];
logic [7:0] matrixB_tb [0:N-1][0:N-1];
wire [sum_width-1:0] result_tb [0:N-1][0:N-1];


accelerator #(
    .N(N),
    .sum_width(sum_width)
) dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .matrixA(matrixA),
    .matrixB(matrixB),
    .M(M),
    .K(K),
    .P(P),
    .done(done),
    .result(result)
);

//automaticall run and compare matrix multipplication results
task automatic runAndCheckResult; 
    logic [sum_width-1:0] expected;

    begin
        //start accelerator
        start = 1'b1;
        @(posedge clk);
        #1;
        start = 1'b0;

        //wait for result
        wait(done);

        // check only valid C elements
        for (int i = 0; i < M; i++) begin
            for (int j = 0; j < P; j++) begin

                expected = '0;

                // calculate expected C[i][j]
                for (int k = 0; k < K; k++) begin
                    expected = expected + matrixA_tb[i][k] * matrixB_tb[k][j];
                end

                assert (result_tb[i][j] == expected)
                    else $error("result[%0d][%0d]: expected %0d, got %0d", i, j, expected, result_tb[i][j]);
            end
        end

        //have to wait for posedge after done to let accelerator fsm go back to idle
        @(posedge clk);
        #1;
    end
endtask

//zeros matrices
task automatic clearMatrices;
    begin
        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                matrixA_tb[i][j] = '0;
                matrixB_tb[i][j] = '0;
            end
        end
    end
endtask

//test random input sizes and values and check them
task automatic randomTest(input int numberOfTests);
    begin
        for (int test = 0; test < numberOfTests; test++) begin

            clearMatrices();

            M = $urandom_range(N, 1);
            K = $urandom_range(N, 1);
            P = $urandom_range(N, 1);

            //randomize valid elements of A
            for (int row = 0; row < M; row++) begin
                for (int col = 0; col < K; col++) begin
                    matrixA_tb[row][col] = $urandom_range(255, 0);
                end
            end

            //randomize valid elements of B
            for (int row = 0; row < K; row++) begin
                for (int col = 0; col < P; col++) begin
                    matrixB_tb[row][col] = $urandom_range(255, 0);
                end
            end

            $display(
                "Random test %0d: (%0dx%0d) x (%0dx%0d)", test + 1, M, K, K, P);

            runAndCheckResult();

        end
    end
endtask

//generate wires from unpacked to packed arrays
genvar r;
genvar c;

generate
    for (r = 0; r < N; r++) begin : gen_tb_rows
        for (c = 0; c < N; c++) begin : gen_tb_cols

            assign matrixA[r][c] = matrixA_tb[r][c];
            assign matrixB[r][c] = matrixB_tb[r][c];

            assign result_tb[r][c] = result[r][c];

        end
    end
endgenerate

always #5 clk = ~clk;

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, systolicArrayMxP_tb);
    $display("3x2 ((3x4) x (4x2)) TB started");

    clk = 0;
    reset = 1;
    start = 0;

    @(posedge clk);
    #1;
    reset = 0;

    clearMatrices();

    //regular values for a non NxN matrix 
    M = 8'd3;
    K = 8'd4;
    P = 8'd2;
    // A =
    // [ 1   2   3   4  ]
    // [ 5   6   7   8  ]
    // [ 9  10  11  12 ]

    matrixA_tb[0][0] = 8'd1;
    matrixA_tb[0][1] = 8'd2;
    matrixA_tb[0][2] = 8'd3;
    matrixA_tb[0][3] = 8'd4;

    matrixA_tb[1][0] = 8'd5;
    matrixA_tb[1][1] = 8'd6;
    matrixA_tb[1][2] = 8'd7;
    matrixA_tb[1][3] = 8'd8;

    matrixA_tb[2][0] = 8'd9;
    matrixA_tb[2][1] = 8'd10;
    matrixA_tb[2][2] = 8'd11;
    matrixA_tb[2][3] = 8'd12;


    // B =
    // [ 1  2 ]
    // [ 3  4 ]
    // [ 5  6 ]
    // [ 7  8 ]

    matrixB_tb[0][0] = 8'd1;
    matrixB_tb[0][1] = 8'd2;

    matrixB_tb[1][0] = 8'd3;
    matrixB_tb[1][1] = 8'd4;

    matrixB_tb[2][0] = 8'd5;
    matrixB_tb[2][1] = 8'd6;

    matrixB_tb[3][0] = 8'd7;
    matrixB_tb[3][1] = 8'd8;
    
    runAndCheckResult();

    clearMatrices();

    //test (1x1) x (1x1) mm
    M = 1;
    K = 1;
    P = 1;

    matrixA_tb[0][0] = 8'd7;

    matrixB_tb[0][0] = 8'd9;

    runAndCheckResult();

    clearMatrices();
    //test (1x1) x (1x8) mm

    M = 1;
    K = 1;
    P = 8;

    matrixA_tb[0][0] = 8'd3;

    matrixB_tb[0][0] = 8'd1;
    matrixB_tb[0][1] = 8'd2;
    matrixB_tb[0][2] = 8'd3;
    matrixB_tb[0][3] = 8'd4;
    matrixB_tb[0][4] = 8'd5;
    matrixB_tb[0][5] = 8'd6;
    matrixB_tb[0][6] = 8'd7;
    matrixB_tb[0][7] = 8'd8;

    runAndCheckResult();

    clearMatrices();

    //test max k values (1x8) x (8x1)
    M = 1;
    K = 8;
    P = 1;

    matrixA_tb[0][0] = 8'd1;
    matrixA_tb[0][1] = 8'd2;
    matrixA_tb[0][2] = 8'd3;
    matrixA_tb[0][3] = 8'd4;
    matrixA_tb[0][4] = 8'd5;
    matrixA_tb[0][5] = 8'd6;
    matrixA_tb[0][6] = 8'd7;
    matrixA_tb[0][7] = 8'd8;

    matrixB_tb[0][0] = 8'd8;
    matrixB_tb[1][0] = 8'd7;
    matrixB_tb[2][0] = 8'd6;
    matrixB_tb[3][0] = 8'd5;
    matrixB_tb[4][0] = 8'd4;
    matrixB_tb[5][0] = 8'd3;
    matrixB_tb[6][0] = 8'd2;
    matrixB_tb[7][0] = 8'd1;

    runAndCheckResult();

    clearMatrices();


    //test 1 k value (8x1) x (1x8)
    M = 8;
    K = 1;
    P = 8;

    matrixA_tb[0][0] = 8'd1;
    matrixA_tb[1][0] = 8'd2;
    matrixA_tb[2][0] = 8'd3;
    matrixA_tb[3][0] = 8'd4;
    matrixA_tb[4][0] = 8'd5;
    matrixA_tb[5][0] = 8'd6;
    matrixA_tb[6][0] = 8'd7;
    matrixA_tb[7][0] = 8'd8;

    matrixB_tb[0][0] = 8'd1;
    matrixB_tb[0][1] = 8'd2;
    matrixB_tb[0][2] = 8'd3;
    matrixB_tb[0][3] = 8'd4;
    matrixB_tb[0][4] = 8'd5;
    matrixB_tb[0][5] = 8'd6;
    matrixB_tb[0][6] = 8'd7;
    matrixB_tb[0][7] = 8'd8;

    runAndCheckResult();

    clearMatrices();

    //test full (8x8) x (8x8)
    M = 8;
    K = 8;
    P = 8;

    for (int i = 0; i < 8; i++) begin
        for (int j = 0; j < 8; j++) begin
            matrixA_tb[i][j] = i + j + 1;
            matrixB_tb[i][j] = (i * 2) + j + 1;
        end
    end

    runAndCheckResult();

    clearMatrices();

    //test 1 k value on rectangular calculation (5 x 1) x (1 x 6)
    M = 5;
    K = 1;
    P = 6;

    matrixA_tb[0][0] = 8'd2;
    matrixA_tb[1][0] = 8'd4;
    matrixA_tb[2][0] = 8'd6;
    matrixA_tb[3][0] = 8'd8;
    matrixA_tb[4][0] = 8'd10;

    matrixB_tb[0][0] = 8'd1;
    matrixB_tb[0][1] = 8'd3;
    matrixB_tb[0][2] = 8'd5;
    matrixB_tb[0][3] = 8'd7;
    matrixB_tb[0][4] = 8'd9;
    matrixB_tb[0][5] = 8'd11;

    runAndCheckResult();

    //starts with clear matrices in the task 
    randomTest(500);

    $display("All accelerator tests finished.");
    $finish;

end

endmodule