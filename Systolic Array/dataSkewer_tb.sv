`timescale 1ns/1ps

module dataSkewer_tb;

localparam int N = 4;

logic clk;
logic reset;

logic [N-1:0][7:0] rawA;
logic [N-1:0][7:0] rawB;

logic [N-1:0] rawAValid;
logic [N-1:0] rawBValid;

logic [N-1:0][7:0] skewedA;
logic [N-1:0][7:0] skewedB;

logic [N-1:0] skewedAValid;
logic [N-1:0] skewedBValid;

always #5 clk = ~clk;

dataSkewer #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),

    .rawA(rawA),
    .rawB(rawB),

    .rawAValid(rawAValid),
    .rawBValid(rawBValid),

    .skewedA(skewedA),
    .skewedB(skewedB),

    .skewedAValid(skewedAValid),
    .skewedBValid(skewedBValid)
);

initial begin
    clk = 0;
    reset = 1;

    for (int i = 0; i < N; i++) begin
        rawA[i] = 0;
        rawB[i] = 0;

        rawAValid[i] = 0;
        rawBValid[i] = 0;
    end

    @(posedge clk);
    @(posedge clk);

    //change inputs on falling edge so that they are stable
    @(negedge clk);
    reset = 0;

    //send A and B values
    rawA[0] = 10;
    rawA[1] = 20;
    rawA[2] = 30;
    rawA[3] = 40;

    rawB[0] = 50;
    rawB[1] = 60;
    rawB[2] = 70;
    rawB[3] = 80;
    
    //mark all the lanes as valid data
    for (int i = 0; i < N; i++) begin
        rawAValid[i] = 1;
        rawBValid[i] = 1;
    end
    #1;

    //lane 0 should have no delay so check now
    if (skewedA[0] !== 8'd10 || skewedAValid[0] !== 1)
        $fatal(1, "Lane 0 A failed");

    if (skewedB[0] !== 8'd50 || skewedBValid[0] !== 1)
        $fatal(1, "Lane 0 B failed");

    @(posedge clk);
    #1;

    if (skewedA[1] !== 8'd20 || skewedAValid[1] !== 1'b1)
        $fatal(1, "Lane 1 A failed");

    if (skewedB[1] !== 8'd60 || skewedBValid[1] !== 1'b1)
        $fatal(1, "Lane 1 B failed");

    //batch has been captured so turn valid off to not enter the same values again
    @(negedge clk);
    for (int i = 0; i < N; i++) begin
        rawAValid[i] = 0;
        rawBValid[i] = 0;

        rawA[i] = 0;
        rawB[i] = 0;
    end


    @(posedge clk);
    #1;

    if (skewedA[2] !== 8'd30 || skewedAValid[2] !== 1'b1)
        $fatal(1, "Lane 2 A failed");

    if (skewedB[2] !== 8'd70 || skewedBValid[2] !== 1'b1)
        $fatal(1, "Lane 2 B failed");

    @(posedge clk);
    #1;

    if (skewedA[3] !== 8'd40 || skewedAValid[3] !== 1'b1)
        $fatal(1, "Lane 3 A failed");

    if (skewedB[3] !== 8'd80 || skewedBValid[3] !== 1'b1)
        $fatal(1, "Lane 3 B failed");


    //al four lanes arrived after their expected delays
    $display("dataSkewer test passed");
    $finish;

end

endmodule