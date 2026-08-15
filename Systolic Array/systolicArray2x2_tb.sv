`timescale 1ns/1ps

module systolicArray2x2_tb;

logic clk;
logic reset;
logic clear;
logic [7:0] dataInA0;
logic [7:0] dataInA1;
logic [7:0] dataInB0;
logic [7:0] dataInB1;
logic AValidIn0;
logic AValidIn1;
logic BValidIn0;
logic BValidIn1;

logic [17:0] sum00;
logic [17:0] sum01;
logic [17:0] sum10;
logic [17:0] sum11;

systolicArray2x2 dut(
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .dataInA0(dataInA0),
    .dataInA1(dataInA1),
    .dataInB0(dataInB0),
    .dataInB1(dataInB1),
    .AValidIn0(AValidIn0),
    .AValidIn1(AValidIn1),
    .BValidIn0(BValidIn0),
    .BValidIn1(BValidIn1),
    .sum00(sum00),
    .sum01(sum01),
    .sum10(sum10),
    .sum11(sum11)
);

always #5 clk = ~clk;

initial begin

    clk = 1'b0;
    reset = 1'b1;
    clear = 1'b0;

    dataInA[0] = 8'b0;
    dataInA[1] = 8'b0;
    dataInA[2] = 8'b0;
    dataInA[3] = 8'b0;

    dataInB[0] = 8'b0;
    dataInB[1] = 8'b0;
    dataInB[2] = 8'b0;
    dataInB[3] = 8'b0;

    AValidIn[0] = 1'b0;
    AValidIn[1] = 1'b0;
    AValidIn[2] = 1'b0;
    AValidIn[3] = 1'b0;

    BValidIn[0] = 1'b0;
    BValidIn[1] = 1'b0;
    BValidIn[2] = 1'b0;
    BValidIn[3] = 1'b0;

    @(posedge clk);
    #1;

    //clock cycle 1
    reset = 1'b0;

    dataInA[0] = 8'd1;
    AValidIn[0] = 1'b1;

    dataInB[0] = 8'd1;
    BValidIn[0] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][0] !== 18'd1)
        $fatal(1, "sum[0][0] clock cycle 1 failed.");

    //clock cycle 2
    dataInA[0] = 8'd2;
    AValidIn[0] = 1'b1;

    dataInA[1] = 8'd5;
    AValidIn[1] = 1'b1;

    dataInB[0] = 8'd5;
    BValidIn[0] = 1'b1;

    dataInB[1] = 8'd2;
    BValidIn[1] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][0] !== 18'd11)
        $fatal(1, "sum[0][0] clock cycle 2 failed.");

    if (sum[0][1] !== 18'd2)
        $fatal(1, "sum[0][1] clock cycle 2 failed.");

    if (sum[1][0] !== 18'd5)
        $fatal(1, "sum[1][0] clock cycle 2 failed.");

    //clock cycle 3
    dataInA[0] = 8'd3;
    AValidIn[0] = 1'b1;

    dataInA[1] = 8'd6;
    AValidIn[1] = 1'b1;

    dataInA[2] = 8'd9;
    AValidIn[2] = 1'b1;

    dataInB[0] = 8'd9;
    BValidIn[0] = 1'b1;

    dataInB[1] = 8'd6;
    BValidIn[1] = 1'b1;

    dataInB[2] = 8'd3;
    BValidIn[2] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][0] !== 18'd38)
        $fatal(1, "sum[0][0] clock cycle 3 failed.");

    if (sum[0][1] !== 18'd14)
        $fatal(1, "sum[0][1] clock cycle 3 failed.");

    if (sum[0][2] !== 18'd3)
        $fatal(1, "sum[0][2] clock cycle 3 failed.");

    if (sum[1][0] !== 18'd35)
        $fatal(1, "sum[1][0] clock cycle 3 failed.");

    if (sum[1][1] !== 18'd10)
        $fatal(1, "sum[1][1] clock cycle 3 failed.");

    if (sum[2][0] !== 18'd9)
        $fatal(1, "sum[2][0] clock cycle 3 failed.");

    //clock cycle 4
    dataInA[0] = 8'd4;
    AValidIn[0] = 1'b1;

    dataInA[1] = 8'd7;
    AValidIn[1] = 1'b1;

    dataInA[2] = 8'd10;
    AValidIn[2] = 1'b1;

    dataInA[3] = 8'd13;
    AValidIn[3] = 1'b1;

    dataInB[0] = 8'd13;
    BValidIn[0] = 1'b1;

    dataInB[1] = 8'd10;
    BValidIn[1] = 1'b1;

    dataInB[2] = 8'd7;
    BValidIn[2] = 1'b1;

    dataInB[3] = 8'd4;
    BValidIn[3] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][0] !== 18'd90)
        $fatal(1, "sum[0][0] clock cycle 4 failed.");

    if (sum[0][1] !== 18'd44)
        $fatal(1, "sum[0][1] clock cycle 4 failed.");

    if (sum[0][2] !== 18'd17)
        $fatal(1, "sum[0][2] clock cycle 4 failed.");

    if (sum[0][3] !== 18'd4)
        $fatal(1, "sum[0][3] clock cycle 4 failed.");

    if (sum[1][0] !== 18'd98)
        $fatal(1, "sum[1][0] clock cycle 4 failed.");

    if (sum[1][1] !== 18'd46)
        $fatal(1, "sum[1][1] clock cycle 4 failed.");

    if (sum[1][2] !== 18'd15)
        $fatal(1, "sum[1][2] clock cycle 4 failed.");

    if (sum[2][0] !== 18'd59)
        $fatal(1, "sum[2][0] clock cycle 4 failed.");

    if (sum[2][1] !== 18'd18)
        $fatal(1, "sum[2][1] clock cycle 4 failed.");

    if (sum[3][0] !== 18'd13)
        $fatal(1, "sum[3][0] clock cycle 4 failed.");

    //clock cycle 5
    AValidIn[0] = 1'b0;
    BValidIn[0] = 1'b0;

    dataInA[1] = 8'd8;
    AValidIn[1] = 1'b1;

    dataInA[2] = 8'd11;
    AValidIn[2] = 1'b1;

    dataInA[3] = 8'd14;
    AValidIn[3] = 1'b1;

    dataInB[1] = 8'd14;
    BValidIn[1] = 1'b1;

    dataInB[2] = 8'd11;
    BValidIn[2] = 1'b1;

    dataInB[3] = 8'd8;
    BValidIn[3] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][1] !== 18'd100)
        $fatal(1, "sum[0][1] clock cycle 5 failed.");

    if (sum[0][2] !== 18'd50)
        $fatal(1, "sum[0][2] clock cycle 5 failed.");

    if (sum[0][3] !== 18'd20)
        $fatal(1, "sum[0][3] clock cycle 5 failed.");

    if (sum[1][0] !== 18'd202)
        $fatal(1, "sum[1][0] clock cycle 5 failed.");

    if (sum[1][1] !== 18'd116)
        $fatal(1, "sum[1][1] clock cycle 5 failed.");

    if (sum[1][2] !== 18'd57)
        $fatal(1, "sum[1][2] clock cycle 5 failed.");

    if (sum[1][3] !== 18'd20)
        $fatal(1, "sum[1][3] clock cycle 5 failed.");

    if (sum[2][0] !== 18'd158)
        $fatal(1, "sum[2][0] clock cycle 5 failed.");

    if (sum[2][1] !== 18'd78)
        $fatal(1, "sum[2][1] clock cycle 5 failed.");

    if (sum[2][2] !== 18'd27)
        $fatal(1, "sum[2][2] clock cycle 5 failed.");

    if (sum[3][0] !== 18'd83)
        $fatal(1, "sum[3][0] clock cycle 5 failed.");

    if (sum[3][1] !== 18'd26)
        $fatal(1, "sum[3][1] clock cycle 5 failed.");

    //clock cycle 6
    AValidIn[1] = 1'b0;
    BValidIn[1] = 1'b0;

    dataInA[2] = 8'd12;
    AValidIn[2] = 1'b1;

    dataInA[3] = 8'd15;
    AValidIn[3] = 1'b1;

    dataInB[2] = 8'd15;
    BValidIn[2] = 1'b1;

    dataInB[3] = 8'd12;
    BValidIn[3] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][2] !== 18'd110)
        $fatal(1, "sum[0][2] clock cycle 6 failed.");

    if (sum[0][3] !== 18'd56)
        $fatal(1, "sum[0][3] clock cycle 6 failed.");

    if (sum[1][1] !== 18'd228)
        $fatal(1, "sum[1][1] clock cycle 6 failed.");

    if (sum[1][2] !== 18'd134)
        $fatal(1, "sum[1][2] clock cycle 6 failed.");

    if (sum[1][3] !== 18'd68)
        $fatal(1, "sum[1][3] clock cycle 6 failed.");

    if (sum[2][0] !== 18'd314)
        $fatal(1, "sum[2][0] clock cycle 6 failed.");

    if (sum[2][1] !== 18'd188)
        $fatal(1, "sum[2][1] clock cycle 6 failed.");

    if (sum[2][2] !== 18'd97)
        $fatal(1, "sum[2][2] clock cycle 6 failed.");

    if (sum[2][3] !== 18'd36)
        $fatal(1, "sum[2][3] clock cycle 6 failed.");

    if (sum[3][0] !== 18'd218)
        $fatal(1, "sum[3][0] clock cycle 6 failed.");

    if (sum[3][1] !== 18'd110)
        $fatal(1, "sum[3][1] clock cycle 6 failed.");

    if (sum[3][2] !== 18'd39)
        $fatal(1, "sum[3][2] clock cycle 6 failed.");

    //clock cycle 7
    AValidIn[2] = 1'b0;
    BValidIn[2] = 1'b0;

    dataInA[3] = 8'd16;
    AValidIn[3] = 1'b1;

    dataInB[3] = 8'd16;
    BValidIn[3] = 1'b1;

    @(posedge clk);
    #1;

    if (sum[0][3] !== 18'd120)
        $fatal(1, "sum[0][3] clock cycle 7 failed.");

    if (sum[1][2] !== 18'd254)
        $fatal(1, "sum[1][2] clock cycle 7 failed.");

    if (sum[1][3] !== 18'd152)
        $fatal(1, "sum[1][3] clock cycle 7 failed.");

    if (sum[2][1] !== 18'd356)
        $fatal(1, "sum[2][1] clock cycle 7 failed.");

    if (sum[2][2] !== 18'd218)
        $fatal(1, "sum[2][2] clock cycle 7 failed.");

    if (sum[2][3] !== 18'd116)
        $fatal(1, "sum[2][3] clock cycle 7 failed.");

    if (sum[3][0] !== 18'd426)
        $fatal(1, "sum[3][0] clock cycle 7 failed.");

    if (sum[3][1] !== 18'd260)
        $fatal(1, "sum[3][1] clock cycle 7 failed.");

    if (sum[3][2] !== 18'd137)
        $fatal(1, "sum[3][2] clock cycle 7 failed.");

    if (sum[3][3] !== 18'd52)
        $fatal(1, "sum[3][3] clock cycle 7 failed.");

    // No more matrix data entering the array
    AValidIn[3] = 1'b0;
    BValidIn[3] = 1'b0;

    //clock cycle 8
    @(posedge clk);
    #1;

    if (sum[1][3] !== 18'd280)
        $fatal(1, "sum[1][3] clock cycle 8 failed.");

    if (sum[2][2] !== 18'd398)
        $fatal(1, "sum[2][2] clock cycle 8 failed.");

    if (sum[2][3] !== 18'd248)
        $fatal(1, "sum[2][3] clock cycle 8 failed.");

    if (sum[3][1] !== 18'd484)
        $fatal(1, "sum[3][1] clock cycle 8 failed.");

    if (sum[3][2] !== 18'd302)
        $fatal(1, "sum[3][2] clock cycle 8 failed.");

    if (sum[3][3] !== 18'd164)
        $fatal(1, "sum[3][3] clock cycle 8 failed.");

    //clock cycle 9
    @(posedge clk);
    #1;

    if (sum[2][3] !== 18'd440)
        $fatal(1, "sum[2][3] clock cycle 9 failed.");

    if (sum[3][2] !== 18'd542)
        $fatal(1, "sum[3][2] clock cycle 9 failed.");

    if (sum[3][3] !== 18'd344)
        $fatal(1, "sum[3][3] clock cycle 9 failed.");

    //clock cycle 10
    @(posedge clk);
    #1;

    if (sum[3][3] !== 18'd600)
        $fatal(1, "sum[3][3] clock cycle 10 failed.");

    // Check complete final matrix
    if (sum[0][0] !== 18'd90)
        $fatal(1, "Final sum[0][0] failed.");

    if (sum[0][1] !== 18'd100)
        $fatal(1, "Final sum[0][1] failed.");

    if (sum[0][2] !== 18'd110)
        $fatal(1, "Final sum[0][2] failed.");

    if (sum[0][3] !== 18'd120)
        $fatal(1, "Final sum[0][3] failed.");

    if (sum[1][0] !== 18'd202)
        $fatal(1, "Final sum[1][0] failed.");

    if (sum[1][1] !== 18'd228)
        $fatal(1, "Final sum[1][1] failed.");

    if (sum[1][2] !== 18'd254)
        $fatal(1, "Final sum[1][2] failed.");

    if (sum[1][3] !== 18'd280)
        $fatal(1, "Final sum[1][3] failed.");

    if (sum[2][0] !== 18'd314)
        $fatal(1, "Final sum[2][0] failed.");

    if (sum[2][1] !== 18'd356)
        $fatal(1, "Final sum[2][1] failed.");

    if (sum[2][2] !== 18'd398)
        $fatal(1, "Final sum[2][2] failed.");

    if (sum[2][3] !== 18'd440)
        $fatal(1, "Final sum[2][3] failed.");

    if (sum[3][0] !== 18'd426)
        $fatal(1, "Final sum[3][0] failed.");

    if (sum[3][1] !== 18'd484)
        $fatal(1, "Final sum[3][1] failed.");

    if (sum[3][2] !== 18'd542)
        $fatal(1, "Final sum[3][2] failed.");

    if (sum[3][3] !== 18'd600)
        $fatal(1, "Final sum[3][3] failed.");

    $display("All tests passed.");
    $finish;
end

endmodule