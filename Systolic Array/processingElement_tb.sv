`timescale 1ns/1ps

module processingElement_tb;

logic clk;
logic clear;
logic reset;

logic signed [7:0] dataInA;
logic signed [7:0] dataInB;
logic AValidIn;
logic BValidIn;

logic signed [7:0] dataOutA;
logic signed [7:0] dataOutB;
logic AValidOut;
logic BValidOut;
logic signed [17:0] sum;

processingElement dut(
    .clk(clk),
    .clear(clear),
    .reset(reset),
    .dataInA(dataInA),
    .dataInB(dataInB),
    .AValidIn(AValidIn),
    .BValidIn(BValidIn),
    .dataOutA(dataOutA),
    .dataOutB(dataOutB),
    .AValidOut(AValidOut),
    .BValidOut(BValidOut),
    .sum(sum)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    clear = 1'b0;
    reset = 1'b1;
    dataInA = 8'b0;
    dataInB = 8'b0;
    AValidIn = 1'b0;
    BValidIn = 1'b0;

    @(posedge clk);
    #1;

    if (sum !== 18'b0)
        $fatal(1, "Initial reset failed (sum).");

    if (AValidOut !== 1'b0)
        $fatal(1, "Initial reset failed (AValidOut).");

    if (BValidOut !== 1'b0)
        $fatal(1, "Initial reset failed (BValidOut).");

    reset = 1'b0;
    dataInA = 8'd2;
    dataInB = 8'd3;
    AValidIn = 1'b1;
    BValidIn = 1'b1;

    @(posedge clk);
    #1;

    if (sum !== 18'd6)
        $fatal(1, "First accumulate failed. (2 x 3 = 6).");

    dataInA = 8'd4;
    dataInB = 8'd5;

    @(posedge clk);
    #1;

    if (sum !== 18'd26)
        $fatal(1, "Second accumulate failed. (6 + (4 x 5) = 26).");

    AValidIn = 1'b0;

    @(posedge clk);
    #1;

    if (sum !== 18'd26)
        $fatal(1, "AValidIn low failed.");

    AValidIn = 1'b1;
    BValidIn = 1'b0;

    @(posedge clk);
    #1;

    if (sum !== 18'd26)
        $fatal(1, "BValidIn low failed.");

    AValidIn = 1'b0;
    BValidIn = 1'b0;

    @(posedge clk);
    #1;

    if (sum !== 18'd26)
        $fatal(1, "A and BValid in low failed.");

    clear = 1'b1;

    @(posedge clk);
    #1;

    if (sum !== 18'b0)
        $fatal(1, "clear failed.");

    if (dataOutA !== 8'd4)
        $fatal(1, "dataOutA failed.");

    if (dataOutB !== 8'd5)
        $fatal(1, "dataOutB failed.");

    if (AValidOut !== 1'b0)
        $fatal(1, "AValidOut failed.");

    if (BValidOut !== 1'b0)
        $fatal(1, "BValidOut failed.");


    //signed calculation tests
    clear = 1'b0;
    AValidIn = 1'b1;
    BValidIn = 1'b1;

    //neg x pos
    dataInA = -8'sd3;
    dataInB = 8'sd4;

    @(posedge clk);
    #1;

    if (sum !== -18'sd12)
        $fatal(1, "Signed multiply failed. (-3 x 4 = -12).");


    // pos x neg
    dataInA = 8'sd3;
    dataInB = -8'sd4;

    @(posedge clk);
    #1;

    if (sum !== -18'sd24)
        $fatal(1, "Signed accumulate failed. (-12 + (3 x -4) = -24).");


    // neg x neg
    dataInA = -8'sd3;
    dataInB = -8'sd4;

    @(posedge clk);
    #1;

    if (sum !== -18'sd12)
        $fatal(1, "Signed accumulate failed. (-24 + (-3 x -4) = -12).");


    // pos x pos
    dataInA = 8'sd3;
    dataInB = 8'sd4;

    @(posedge clk);
    #1;

    if (sum !== 18'sd0)
        $fatal(1, "Signed accumulate failed. (-12 + (3 x 4) = 0).");


    //signed max edge case
    clear = 1'b1;

    @(posedge clk);
    #1;

    clear = 1'b0;
    dataInA = -8'sd128;
    dataInB = 8'sd127;

    @(posedge clk);
    #1;

    if (sum !== -18'sd16256)
        $fatal(1, "Signed boundary multiply failed. (-128 x 127 = -16256).");


    $display("All processing element tests finished.");
    $finish;

end

endmodule