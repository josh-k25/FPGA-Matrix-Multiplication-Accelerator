`timescale 1ns/1ps

module singleMacBenchmark4x4_tb;

localparam int N = 4;
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
    ) dut(
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
            $fatal(1,"C[%0d] failed: expected %0d, got %0d", index, expected, dut.RAMC.ramC[index]);
    end
endtask


initial begin

    clk = 0;
    reset = 1;
    start = 0;
    cycles = 0;

    #1;


    //same Matrix A as CPU benchmark
    dut.RAMA.ramA[0]  = 8'd1;
    dut.RAMA.ramA[1]  = 8'd2;
    dut.RAMA.ramA[2]  = 8'd3;
    dut.RAMA.ramA[3]  = 8'd4;

    dut.RAMA.ramA[4]  = 8'd5;
    dut.RAMA.ramA[5]  = 8'd6;
    dut.RAMA.ramA[6]  = 8'd7;
    dut.RAMA.ramA[7]  = 8'd8;

    dut.RAMA.ramA[8]  = 8'd9;
    dut.RAMA.ramA[9]  = 8'd10;
    dut.RAMA.ramA[10] = 8'd11;
    dut.RAMA.ramA[11] = 8'd12;

    dut.RAMA.ramA[12] = 8'd13;
    dut.RAMA.ramA[13] = 8'd14;
    dut.RAMA.ramA[14] = 8'd15;
    dut.RAMA.ramA[15] = 8'd16;


    //same Matrix B as CPU benchmark
    dut.RAMB.ramB[0]  = 8'd16;
    dut.RAMB.ramB[1]  = 8'd15;
    dut.RAMB.ramB[2]  = 8'd14;
    dut.RAMB.ramB[3]  = 8'd13;

    dut.RAMB.ramB[4]  = 8'd12;
    dut.RAMB.ramB[5]  = 8'd11;
    dut.RAMB.ramB[6]  = 8'd10;
    dut.RAMB.ramB[7]  = 8'd9;

    dut.RAMB.ramB[8]  = 8'd8;
    dut.RAMB.ramB[9]  = 8'd7;
    dut.RAMB.ramB[10] = 8'd6;
    dut.RAMB.ramB[11] = 8'd5;

    dut.RAMB.ramB[12] = 8'd4;
    dut.RAMB.ramB[13] = 8'd3;
    dut.RAMB.ramB[14] = 8'd2;
    dut.RAMB.ramB[15] = 8'd1;


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

    //start timing AFTER matrices have already been loaded
    cycles = 0;


    //count until accelerator asserts done
    while ((done !== 1'b1) && (cycles < 1000)) begin
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
    checkResult(0,  80);
    checkResult(1,  70);
    checkResult(2,  60);
    checkResult(3,  50);

    checkResult(4,  240);
    checkResult(5,  214);
    checkResult(6,  188);
    checkResult(7,  162);

    checkResult(8,  400);
    checkResult(9,  358);
    checkResult(10, 316);
    checkResult(11, 274);

    checkResult(12, 560);
    checkResult(13, 502);
    checkResult(14, 444);
    checkResult(15, 386);


    $display("Single-MAC matrix multiplication passed.");
    $display("Single-MAC cycles: %0d", cycles);

    $finish;

end

endmodule