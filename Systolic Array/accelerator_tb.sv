`timescale 1ns/1ps

module accelerator_tb;

localparam int N = 4;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic start;

logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;

logic done;
logic [N-1:0][N-1:0][sum_width-1:0] result;

//expected for random verification
logic [N-1:0][N-1:0][sum_width-1:0] expected;

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
    
    $display("NxN TB started");
    //reset accelerator
    clk = 1'b0;
    reset = 1'b1;
    start = 1'b0;

    matrixA = '0;
    matrixB = '0;

    //digits 1 - 16 tests
    @(posedge clk);
    #1;

    reset = 1'b0;

    matrixA = {
        8'd16, 8'd15, 8'd14, 8'd13,
        8'd12, 8'd11, 8'd10, 8'd9,
        8'd8, 8'd7, 8'd6, 8'd5,
        8'd4, 8'd3, 8'd2, 8'd1
    };

    matrixB = {
        8'd16, 8'd15, 8'd14, 8'd13,
        8'd12, 8'd11, 8'd10, 8'd9,
        8'd8, 8'd7, 8'd6, 8'd5,
        8'd4, 8'd3, 8'd2, 8'd1
    };

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    wait (done == 1'b1);
    #1;

    if (result[0][0] !== 18'd90)
        $fatal(1, "result[0][0] failed.");

    if (result[0][1] !== 18'd100)
        $fatal(1, "result[0][1] failed.");

    if (result[0][2] !== 18'd110)
        $fatal(1, "result[0][2] failed.");

    if (result[0][3] !== 18'd120)
        $fatal(1, "result[0][3] failed.");


    if (result[1][0] !== 18'd202)
        $fatal(1, "result[1][0] failed.");

    if (result[1][1] !== 18'd228)
        $fatal(1, "result[1][1] failed.");

    if (result[1][2] !== 18'd254)
        $fatal(1, "result[1][2] failed.");

    if (result[1][3] !== 18'd280)
        $fatal(1, "result[1][3] failed.");


    if (result[2][0] !== 18'd314)
        $fatal(1, "result[2][0] failed.");

    if (result[2][1] !== 18'd356)
        $fatal(1, "result[2][1] failed.");

    if (result[2][2] !== 18'd398)
        $fatal(1, "result[2][2] failed.");

    if (result[2][3] !== 18'd440)
        $fatal(1, "result[2][3] failed.");


    if (result[3][0] !== 18'd426)
        $fatal(1, "result[3][0] failed.");

    if (result[3][1] !== 18'd484)
        $fatal(1, "result[3][1] failed.");

    if (result[3][2] !== 18'd542)
        $fatal(1, "result[3][2] failed.");

    if (result[3][3] !== 18'd600)
        $fatal(1, "result[3][3] failed.");

    wait (done == 1'b0);
    #1;

    //second multiplication back to back
    matrixA = {
        8'd103, 8'd187, 8'd9, 8'd154,
        8'd71, 8'd240, 8'd52, 8'd116,
        8'd198, 8'd25, 8'd173, 8'd64,
        8'd211, 8'd89, 8'd142, 8'd37
    };

    matrixB = {
        8'd129, 8'd6, 8'd143, 8'd59,
        8'd218, 8'd164, 8'd31, 8'd105,
        8'd250, 8'd83, 8'd196, 8'd12,
        8'd77, 8'd135, 8'd48, 8'd221
    };

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    wait (done == 1'b1);
    #1;

    if (result[0][0] !== 18'd31675)
        $fatal(1, "result[0][0] failed.");

    if (result[0][1] !== 18'd62540)
        $fatal(1, "result[0][1] failed.");

    if (result[0][2] !== 18'd32643)
        $fatal(1, "result[0][2] failed.");

    if (result[0][3] !== 18'd84970)
        $fatal(1, "result[0][3] failed.");


    if (result[1][0] !== 18'd30527)
        $fatal(1, "result[1][0] failed.");

    if (result[1][1] !== 18'd66069)
        $fatal(1, "result[1][1] failed.");

    if (result[1][2] !== 18'd28287)
        $fatal(1, "result[1][2] failed.");

    if (result[1][3] !== 18'd79170)
        $fatal(1, "result[1][3] failed.");


    if (result[2][0] !== 18'd55649)
        $fatal(1, "result[2][0] failed.");

    if (result[2][1] !== 18'd33353)
        $fatal(1, "result[2][1] failed.");

    if (result[2][2] !== 18'd59762)
        $fatal(1, "result[2][2] failed.");

    if (result[2][3] !== 18'd83411)
        $fatal(1, "result[2][3] failed.");


    if (result[3][0] !== 18'd59854)
        $fatal(1, "result[3][0] failed.");

    if (result[3][1] !== 18'd29682)
        $fatal(1, "result[3][1] failed.");

    if (result[3][2] !== 18'd52823)
        $fatal(1, "result[3][2] failed.");

    if (result[3][3] !== 18'd68161)
        $fatal(1, "result[3][3] failed.");
    
    wait (done == 1'b0);
    #1;

    reset = 1'b1;
    //third multiplication max values
    matrixA = {
        8'd255, 8'd255, 8'd255, 8'd255,
        8'd255, 8'd255, 8'd255, 8'd255,
        8'd255, 8'd255, 8'd255, 8'd255,
        8'd255, 8'd255, 8'd255, 8'd255
    };

    matrixB = {
        8'd255, 8'd255, 8'd255, 8'd255,
        8'd255, 8'd255, 8'd255, 8'd255,
        8'd255, 8'd255, 8'd255, 8'd255,
        8'd255, 8'd255, 8'd255, 8'd255
    };

    @(posedge clk);
    #1;
    reset = 1'b0; 

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    wait (done == 1'b1);
    #1;

    if (result[0][0] !== 18'd260100)
        $fatal(1, "result[0][0] failed.");

    if (result[0][1] !== 18'd260100)
        $fatal(1, "result[0][1] failed.");

    if (result[0][2] !== 18'd260100)
        $fatal(1, "result[0][2] failed.");

    if (result[0][3] !== 18'd260100)
        $fatal(1, "result[0][3] failed.");


    if (result[1][0] !== 18'd260100)
        $fatal(1, "result[1][0] failed.");

    if (result[1][1] !== 18'd260100)
        $fatal(1, "result[1][1] failed.");

    if (result[1][2] !== 18'd260100)
        $fatal(1, "result[1][2] failed.");

    if (result[1][3] !== 18'd260100)
        $fatal(1, "result[1][3] failed.");


    if (result[2][0] !== 18'd260100)
        $fatal(1, "result[2][0] failed.");

    if (result[2][1] !== 18'd260100)
        $fatal(1, "result[2][1] failed.");

    if (result[2][2] !== 18'd260100)
        $fatal(1, "result[2][2] failed.");

    if (result[2][3] !== 18'd260100)
        $fatal(1, "result[2][3] failed.");


    if (result[3][0] !== 18'd260100)
        $fatal(1, "result[3][0] failed.");

    if (result[3][1] !== 18'd260100)
        $fatal(1, "result[3][1] failed.");

    if (result[3][2] !== 18'd260100)
        $fatal(1, "result[3][2] failed.");

    if (result[3][3] !== 18'd260100)
        $fatal(1, "result[3][3] failed.");

    wait (done == 1'b0);
    #1;

    //fourth multiplication all 0 (no reset to check for stale values)
    matrixA = {
        8'd0, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd0
    };

    matrixB = {
        8'd0, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd0
    };

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    wait (done == 1'b1);
    #1;

    wait (done == 1'b1);
    #1;

    if (result[0][0] !== 18'd0)
        $fatal(1, "result[0][0] failed.");

    if (result[0][1] !== 18'd0)
        $fatal(1, "result[0][1] failed.");

    if (result[0][2] !== 18'd0)
        $fatal(1, "result[0][2] failed.");

    if (result[0][3] !== 18'd0)
        $fatal(1, "result[0][3] failed.");


    if (result[1][0] !== 18'd0)
        $fatal(1, "result[1][0] failed.");

    if (result[1][1] !== 18'd0)
        $fatal(1, "result[1][1] failed.");

    if (result[1][2] !== 18'd0)
        $fatal(1, "result[1][2] failed.");

    if (result[1][3] !== 18'd0)
        $fatal(1, "result[1][3] failed.");


    if (result[2][0] !== 18'd0)
        $fatal(1, "result[2][0] failed.");

    if (result[2][1] !== 18'd0)
        $fatal(1, "result[2][1] failed.");

    if (result[2][2] !== 18'd0)
        $fatal(1, "result[2][2] failed.");

    if (result[2][3] !== 18'd0)
        $fatal(1, "result[2][3] failed.");


    if (result[3][0] !== 18'd0)
        $fatal(1, "result[3][0] failed.");

    if (result[3][1] !== 18'd0)
        $fatal(1, "result[3][1] failed.");

    if (result[3][2] !== 18'd0)
        $fatal(1, "result[3][2] failed.");

    if (result[3][3] !== 18'd0)
        $fatal(1, "result[3][3] failed.");

    wait (done == 1'b0);
    #1;

    reset = 1'b1;
    //fifth multiplication random x identity
    matrixA = {
        8'd37,  8'd142, 8'd89,  8'd211,
        8'd64,  8'd173, 8'd25,  8'd198,
        8'd116, 8'd52,  8'd240, 8'd71,
        8'd154, 8'd9,   8'd187, 8'd103
    };

    matrixB = {
        8'd1, 8'd0, 8'd0, 8'd0,
        8'd0, 8'd1, 8'd0, 8'd0,
        8'd0, 8'd0, 8'd1, 8'd0,
        8'd0, 8'd0, 8'd0, 8'd1
    };

    @(posedge clk);
    #1;
    reset = 1'b0; 

    start = 1'b1;

    @(posedge clk);
    #1;

    start = 1'b0;

    wait (done == 1'b1);
    #1;

    if (result[0][0] !== 18'd103)
        $fatal(1, "result[0][0] failed.");

    if (result[0][1] !== 18'd187)
        $fatal(1, "result[0][1] failed.");

    if (result[0][2] !== 18'd9)
        $fatal(1, "result[0][2] failed.");

    if (result[0][3] !== 18'd154)
        $fatal(1, "result[0][3] failed.");


    if (result[1][0] !== 18'd71)
        $fatal(1, "result[1][0] failed.");

    if (result[1][1] !== 18'd240)
        $fatal(1, "result[1][1] failed.");

    if (result[1][2] !== 18'd52)
        $fatal(1, "result[1][2] failed.");

    if (result[1][3] !== 18'd116)
        $fatal(1, "result[1][3] failed.");


    if (result[2][0] !== 18'd198)
        $fatal(1, "result[2][0] failed.");

    if (result[2][1] !== 18'd25)
        $fatal(1, "result[2][1] failed.");

    if (result[2][2] !== 18'd173)
        $fatal(1, "result[2][2] failed.");

    if (result[2][3] !== 18'd64)
        $fatal(1, "result[2][3] failed.");


    if (result[3][0] !== 18'd211)
        $fatal(1, "result[3][0] failed.");

    if (result[3][1] !== 18'd89)
        $fatal(1, "result[3][1] failed.");

    if (result[3][2] !== 18'd142)
        $fatal(1, "result[3][2] failed.");

    if (result[3][3] !== 18'd37)
        $fatal(1, "result[3][3] failed.");

    $display("All accelerator tests passed.");
    $finish;

end

endmodule