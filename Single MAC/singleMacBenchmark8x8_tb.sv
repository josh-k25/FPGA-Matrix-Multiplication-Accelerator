`timescale 1ns/1ps

module singleMacBenchmark8x8_tb;

localparam int N = 8;
localparam int SUM_WIDTH = 16 + $clog2(N);

logic clk;
logic reset;
logic start;
logic done;

logic [SUM_WIDTH-1:0] result;

integer cycles;

datapath #(
    .N(N),
    .SUM_WIDTH(SUM_WIDTH)
) dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .done(done),
    .result(result)
);

always #5 clk = ~clk;


//checks the output matrix stored inside RAMC
task checkResult;
    input integer index;
    input integer expected;

    begin
        if (dut.RAMC.ramC[index] !== expected)
            $fatal(
                1,
                "C[%0d] failed: expected %0d, got %0d",
                index,
                expected,
                dut.RAMC.ramC[index]
            );
    end
endtask


initial begin

    clk = 0;
    reset = 1;
    start = 0;
    cycles = 0;

    #1;


    //matrix A = 1 to 64
    for (int index = 0; index < N*N; index = index + 1) begin
        dut.RAMA.ramA[index] = index + 1;
    end


    //matrix B = 64 to 1
    for (int index = 0; index < N*N; index = index + 1) begin
        dut.RAMB.ramB[index] = N*N - index;
    end


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


    //start timing after matrices have already been loaded
    cycles = 0;


    //count until accelerator asserts done
    while ((done !== 1'b1) && (cycles < 10000)) begin
        @(posedge clk);
        #1;

        cycles = cycles + 1;
    end


    if (done !== 1'b1)
        $fatal(
            1,
            "Single-MAC timed out after %0d cycles",
            cycles
        );


    //expected C = A * B

    checkResult(0, 960);
    checkResult(1, 924);
    checkResult(2, 888);
    checkResult(3, 852);
    checkResult(4, 816);
    checkResult(5, 780);
    checkResult(6, 744);
    checkResult(7, 708);

    checkResult(8, 3264);
    checkResult(9, 3164);
    checkResult(10, 3064);
    checkResult(11, 2964);
    checkResult(12, 2864);
    checkResult(13, 2764);
    checkResult(14, 2664);
    checkResult(15, 2564);

    checkResult(16, 5568);
    checkResult(17, 5404);
    checkResult(18, 5240);
    checkResult(19, 5076);
    checkResult(20, 4912);
    checkResult(21, 4748);
    checkResult(22, 4584);
    checkResult(23, 4420);

    checkResult(24, 7872);
    checkResult(25, 7644);
    checkResult(26, 7416);
    checkResult(27, 7188);
    checkResult(28, 6960);
    checkResult(29, 6732);
    checkResult(30, 6504);
    checkResult(31, 6276);

    checkResult(32, 10176);
    checkResult(33, 9884);
    checkResult(34, 9592);
    checkResult(35, 9300);
    checkResult(36, 9008);
    checkResult(37, 8716);
    checkResult(38, 8424);
    checkResult(39, 8132);

    checkResult(40, 12480);
    checkResult(41, 12124);
    checkResult(42, 11768);
    checkResult(43, 11412);
    checkResult(44, 11056);
    checkResult(45, 10700);
    checkResult(46, 10344);
    checkResult(47, 9988);

    checkResult(48, 14784);
    checkResult(49, 14364);
    checkResult(50, 13944);
    checkResult(51, 13524);
    checkResult(52, 13104);
    checkResult(53, 12684);
    checkResult(54, 12264);
    checkResult(55, 11844);

    checkResult(56, 17088);
    checkResult(57, 16604);
    checkResult(58, 16120);
    checkResult(59, 15636);
    checkResult(60, 15152);
    checkResult(61, 14668);
    checkResult(62, 14184);
    checkResult(63, 13700);


    $display("Single-MAC 8x8 matrix multiplication passed.");
    $display("Single-MAC 8x8 cycles: %0d", cycles);

    $finish;

end

endmodule