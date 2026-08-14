`timescale 1ns/1ps

module systolicArrayNxN_tb;

localparam int N = 2;
localparam int sum_width = 16 + $clog2(N);

logic clk;
logic reset;
logic clear;

logic [7:0] dataInA [0:N-1];
logic [7:0] dataInB [0:N-1];

logic AValidIn [0:N-1];
logic BValidIn [0:N-1];

logic [N-1:0][N-1:0][sum_width - 1:0] sum;

systolicArrayNxN #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .dataInA(dataInA),
    .dataInB(dataInB),
    .AValidIn(AValidIn),
    .BValidIn(BValidIn),
    .sum(sum)
);

always #5 clk = ~clk;

initial begin
    
    clk = 1'b0;
    reset = 1'b1;
    clear = 1'b0;
    dataInA[0] = 8'b0;
    dataInA[1]  = 8'b0;
    dataInB[0] = 8'b0;
    dataInB[1] = 8'b0;
    AValidIn[0] = 1'b0;
    AValidIn[1] = 1'b0;
    BValidIn[0] = 1'b0;
    BValidIn[1] = 1'b0;

    @(posedge clk);
    #1;

    reset = 1'b0;
    dataInA[0] = 8'd1;
    AValidIn[0] = 1'd1;
    dataInB[0] = 8'd5;
    BValidIn[0] = 1'd1;

    @(posedge clk);
    #1;

    if (sum[0][0] !== 18'd5)
        $fatal(1, "sum[0][0] clock cycle 1 failed.");

    dataInA[0] = 8'd2;
    AValidIn[0] = 1'd1;
    dataInB[0] = 8'd7;
    BValidIn[0] = 1'd1;
    dataInA[1]  = 8'd4;
    AValidIn[1] = 1'd1;
    dataInB[1] = 8'd10;
    BValidIn[1] = 1'd1;
    

    @(posedge clk);
    #1;

    if (sum[0][0] !== 18'd19)
        $fatal(1, "sum[0][0] clock cycle 2 failed.");
    
    if (sum[1][0] !== 18'd20)
        $fatal(1, "sum[1][0] clock cycle 2 failed.");

    if (sum[0][1] !== 18'd10)
        $fatal(1, "sum[0][1] clock cycle 2 failed.");
    
    dataInA[1]  = 8'd20;
    AValidIn[1] = 1'd1;
    dataInB[1] = 8'd20;
    BValidIn[1] = 1'd1;
    AValidIn[0] = 1'b0;
    BValidIn[0] = 1'b0;

    @(posedge clk);
    #1;

    if (sum[1][0] !== 18'd160)
        $fatal(1, "sum[1][0] clock cycle 3 failed.");
    
    if (sum[0][1] !== 18'd50)
        $fatal(1, "sum[0][1] clock cycle 3 failed.");

    if (sum[1][1] !== 18'd40)
        $fatal(1, "sum[1][1] clock cycle 3 failed.");

    @(posedge clk);
    #1;

    if (sum[1][1] !== 18'd440)
        $fatal(1, "sum[1][1] clock cycle 4 failed.");

    $display("All tests passed.");
    $finish;
end
endmodule
