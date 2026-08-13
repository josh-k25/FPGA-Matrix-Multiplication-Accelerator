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
    dataInA0 = 8'b0;
    dataInA1 = 8'b0;
    dataInB0 = 8'b0;
    dataInB1 = 8'b0;
    AValidIn0 = 1'b0;
    AValidIn1 = 1'b0;
    BValidIn0 = 1'b0;
    BValidIn1 = 1'b0;

    @(posedge clk);
    #1;

    reset = 1'b0;
    dataInA0 = 8'd1;
    AValidIn0 = 1'd1;
    dataInB0 = 8'd5;
    BValidIn0 = 1'd1;

    @(posedge clk);
    #1;

    if (sum00 !== 18'd5)
        $fatal(1, "sum00 clock cycle 1 failed.");

    dataInA0 = 8'd2;
    AValidIn0 = 1'd1;
    dataInB0 = 8'd7;
    BValidIn0 = 1'd1;
    dataInA1 = 8'd4;
    AValidIn1 = 1'd1;
    dataInB1 = 8'd10;
    BValidIn1 = 1'd1;
    

    @(posedge clk);
    #1;

    if (sum00 !== 18'd19)
        $fatal(1, "sum00 clock cycle 2 failed.");
    
    if (sum10 !== 18'd20)
        $fatal(1, "sum10 clock cycle 2 failed.");

    if (sum01 !== 18'd10)
        $fatal(1, "sum01 clock cycle 2 failed.");
    
    dataInA1 = 8'd20;
    AValidIn1 = 1'd1;
    dataInB1 = 8'd20;
    BValidIn1 = 1'd1;
    AValidIn0 = 1'b0;
    BValidIn0 = 1'b0;

    @(posedge clk);
    #1;

    if (sum10 !== 18'd160)
        $fatal(1, "sum10 clock cycle 3 failed.");
    
    if (sum01 !== 18'd50)
        $fatal(1, "sum01 clock cycle 3 failed.");

    if (sum11 !== 18'd40)
        $fatal(1, "sum11 clock cycle 3 failed.");

    @(posedge clk);
    #1;

    if (sum11 !== 18'd440)
        $fatal(1, "sum11 clock cycle 4 failed.");

    $display("All tests passed.");
    $finish;
end
endmodule
