`timescale 1ns/1ps

module singleMacBenchmark2x2_tb;

localparam int N = 2;
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


    //matrix A
    // [1 2]
    // [3 4]

    dut.RAMA.ramA[0] = 8'd1;
    dut.RAMA.ramA[1] = 8'd2;
    dut.RAMA.ramA[2] = 8'd3;
    dut.RAMA.ramA[3] = 8'd4;


    //matrix B
    // [4 3]
    // [2 1]

    dut.RAMB.ramB[0] = 8'd4;
    dut.RAMB.ramB[1] = 8'd3;
    dut.RAMB.ramB[2] = 8'd2;
    dut.RAMB.ramB[3] = 8'd1;


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
    // [1 2] [4 3]   [ 8  5]
    // [3 4] [2 1] = [20 13]

    checkResult(0, 8);
    checkResult(1, 5);
    checkResult(2, 20);
    checkResult(3, 13);


    $display("Single-MAC 2x2 matrix multiplication passed.");
    $display("Single-MAC 2x2 cycles: %0d", cycles);

    $finish;

end

endmodule