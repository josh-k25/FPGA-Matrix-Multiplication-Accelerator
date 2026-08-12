`timescale 1ns/1ps

module datapath_tb;

logic clk;
logic reset;
logic start;

logic done;
logic [17:0] result;

datapath dut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .done(done),
    .result(result)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;

    #10;
    reset = 0;

    #10;
    start = 1;

    #10;
    start = 0;

    wait(done);

    $display("Matrix multiplication finished");
    $display("C[0][0] = %0d", dut.RAMC.ramC[0]);
    $display("C[0][1] = %0d", dut.RAMC.ramC[1]);
    $display("C[0][2] = %0d", dut.RAMC.ramC[2]);
    $display("C[0][3] = %0d", dut.RAMC.ramC[3]);

    $display("C[1][0] = %0d", dut.RAMC.ramC[4]);
    $display("C[1][1] = %0d", dut.RAMC.ramC[5]);
    $display("C[1][2] = %0d", dut.RAMC.ramC[6]);
    $display("C[1][3] = %0d", dut.RAMC.ramC[7]);

    $display("C[2][0] = %0d", dut.RAMC.ramC[8]);
    $display("C[2][1] = %0d", dut.RAMC.ramC[9]);
    $display("C[2][2] = %0d", dut.RAMC.ramC[10]);
    $display("C[2][3] = %0d", dut.RAMC.ramC[11]);

    $display("C[3][0] = %0d", dut.RAMC.ramC[12]);
    $display("C[3][1] = %0d", dut.RAMC.ramC[13]);
    $display("C[3][2] = %0d", dut.RAMC.ramC[14]);
    $display("C[3][3] = %0d", dut.RAMC.ramC[15]);

    #20;
    $finish;
end

endmodule