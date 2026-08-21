`timescale 1ns/1ps

module systolicBenchmark8x8_tb;

localparam int N = 8;
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


    //Matrix A = values 1 through 64 in row-major order
    //packed-array concatenation is written in reverse index order

    matrixA = {
        8'd64, 8'd63, 8'd62, 8'd61, 8'd60, 8'd59, 8'd58, 8'd57,
        8'd56, 8'd55, 8'd54, 8'd53, 8'd52, 8'd51, 8'd50, 8'd49,
        8'd48, 8'd47, 8'd46, 8'd45, 8'd44, 8'd43, 8'd42, 8'd41,
        8'd40, 8'd39, 8'd38, 8'd37, 8'd36, 8'd35, 8'd34, 8'd33,
        8'd32, 8'd31, 8'd30, 8'd29, 8'd28, 8'd27, 8'd26, 8'd25,
        8'd24, 8'd23, 8'd22, 8'd21, 8'd20, 8'd19, 8'd18, 8'd17,
        8'd16, 8'd15, 8'd14, 8'd13, 8'd12, 8'd11, 8'd10, 8'd9,
        8'd8,  8'd7,  8'd6,  8'd5,  8'd4,  8'd3,  8'd2,  8'd1
    };


    //Matrix B = values 64 through 1 in row-major order

    matrixB = {
        8'd1,  8'd2,  8'd3,  8'd4,  8'd5,  8'd6,  8'd7,  8'd8,
        8'd9,  8'd10, 8'd11, 8'd12, 8'd13, 8'd14, 8'd15, 8'd16,
        8'd17, 8'd18, 8'd19, 8'd20, 8'd21, 8'd22, 8'd23, 8'd24,
        8'd25, 8'd26, 8'd27, 8'd28, 8'd29, 8'd30, 8'd31, 8'd32,
        8'd33, 8'd34, 8'd35, 8'd36, 8'd37, 8'd38, 8'd39, 8'd40,
        8'd41, 8'd42, 8'd43, 8'd44, 8'd45, 8'd46, 8'd47, 8'd48,
        8'd49, 8'd50, 8'd51, 8'd52, 8'd53, 8'd54, 8'd55, 8'd56,
        8'd57, 8'd58, 8'd59, 8'd60, 8'd61, 8'd62, 8'd63, 8'd64
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


    //start timing after matrices are loaded
    cycles = 0;


    while ((done !== 1'b1) && (cycles < 1000)) begin
        @(posedge clk);
        #1;

        cycles = cycles + 1;
    end


    if (done !== 1'b1)
        $fatal(
            1,
            "Systolic 8x8 timed out after %0d cycles",
            cycles
        );


    //expected C = A * B


    //row 0
    checkResult(result[0][0], 0, 0, 960);
    checkResult(result[0][1], 0, 1, 924);
    checkResult(result[0][2], 0, 2, 888);
    checkResult(result[0][3], 0, 3, 852);
    checkResult(result[0][4], 0, 4, 816);
    checkResult(result[0][5], 0, 5, 780);
    checkResult(result[0][6], 0, 6, 744);
    checkResult(result[0][7], 0, 7, 708);

    //row 1
    checkResult(result[1][0], 1, 0, 3264);
    checkResult(result[1][1], 1, 1, 3164);
    checkResult(result[1][2], 1, 2, 3064);
    checkResult(result[1][3], 1, 3, 2964);
    checkResult(result[1][4], 1, 4, 2864);
    checkResult(result[1][5], 1, 5, 2764);
    checkResult(result[1][6], 1, 6, 2664);
    checkResult(result[1][7], 1, 7, 2564);

    //row 2
    checkResult(result[2][0], 2, 0, 5568);
    checkResult(result[2][1], 2, 1, 5404);
    checkResult(result[2][2], 2, 2, 5240);
    checkResult(result[2][3], 2, 3, 5076);
    checkResult(result[2][4], 2, 4, 4912);
    checkResult(result[2][5], 2, 5, 4748);
    checkResult(result[2][6], 2, 6, 4584);
    checkResult(result[2][7], 2, 7, 4420);

    //row 3
    checkResult(result[3][0], 3, 0, 7872);
    checkResult(result[3][1], 3, 1, 7644);
    checkResult(result[3][2], 3, 2, 7416);
    checkResult(result[3][3], 3, 3, 7188);
    checkResult(result[3][4], 3, 4, 6960);
    checkResult(result[3][5], 3, 5, 6732);
    checkResult(result[3][6], 3, 6, 6504);
    checkResult(result[3][7], 3, 7, 6276);

    //row 4
    checkResult(result[4][0], 4, 0, 10176);
    checkResult(result[4][1], 4, 1, 9884);
    checkResult(result[4][2], 4, 2, 9592);
    checkResult(result[4][3], 4, 3, 9300);
    checkResult(result[4][4], 4, 4, 9008);
    checkResult(result[4][5], 4, 5, 8716);
    checkResult(result[4][6], 4, 6, 8424);
    checkResult(result[4][7], 4, 7, 8132);

    //row 5
    checkResult(result[5][0], 5, 0, 12480);
    checkResult(result[5][1], 5, 1, 12124);
    checkResult(result[5][2], 5, 2, 11768);
    checkResult(result[5][3], 5, 3, 11412);
    checkResult(result[5][4], 5, 4, 11056);
    checkResult(result[5][5], 5, 5, 10700);
    checkResult(result[5][6], 5, 6, 10344);
    checkResult(result[5][7], 5, 7, 9988);

    //row 6
    checkResult(result[6][0], 6, 0, 14784);
    checkResult(result[6][1], 6, 1, 14364);
    checkResult(result[6][2], 6, 2, 13944);
    checkResult(result[6][3], 6, 3, 13524);
    checkResult(result[6][4], 6, 4, 13104);
    checkResult(result[6][5], 6, 5, 12684);
    checkResult(result[6][6], 6, 6, 12264);
    checkResult(result[6][7], 6, 7, 11844);

    //row 7
    checkResult(result[7][0], 7, 0, 17088);
    checkResult(result[7][1], 7, 1, 16604);
    checkResult(result[7][2], 7, 2, 16120);
    checkResult(result[7][3], 7, 3, 15636);
    checkResult(result[7][4], 7, 4, 15152);
    checkResult(result[7][5], 7, 5, 14668);
    checkResult(result[7][6], 7, 6, 14184);
    checkResult(result[7][7], 7, 7, 13700); 


    $display("Systolic 8x8 matrix multiplication passed.");
    $display("Systolic 8x8 cycles: %0d", cycles);

    $finish;

end

endmodule