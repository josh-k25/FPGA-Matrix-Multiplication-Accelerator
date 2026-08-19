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

    if (dut.RAMC.ramC[0] !== 18'd90)
        $fatal(1, "C[0][0] failed.");

    if (dut.RAMC.ramC[1] !== 18'd100)
        $fatal(1, "C[0][1] failed.");

    if (dut.RAMC.ramC[2] !== 18'd110)
        $fatal(1, "C[0][2] failed.");

    if (dut.RAMC.ramC[3] !== 18'd120)
        $fatal(1, "C[0][3] failed.");


    if (dut.RAMC.ramC[4] !== 18'd202)
        $fatal(1, "C[1][0] failed.");

    if (dut.RAMC.ramC[5] !== 18'd228)
        $fatal(1, "C[1][1] failed.");

    if (dut.RAMC.ramC[6] !== 18'd254)
        $fatal(1, "C[1][2] failed.");

    if (dut.RAMC.ramC[7] !== 18'd280)
        $fatal(1, "C[1][3] failed.");


    if (dut.RAMC.ramC[8] !== 18'd314)
        $fatal(1, "C[2][0] failed.");

    if (dut.RAMC.ramC[9] !== 18'd356)
        $fatal(1, "C[2][1] failed.");

    if (dut.RAMC.ramC[10] !== 18'd398)
        $fatal(1, "C[2][2] failed.");

    if (dut.RAMC.ramC[11] !== 18'd440)
        $fatal(1, "C[2][3] failed.");


    if (dut.RAMC.ramC[12] !== 18'd426)
        $fatal(1, "C[3][0] failed.");

    if (dut.RAMC.ramC[13] !== 18'd484)
        $fatal(1, "C[3][1] failed.");

    if (dut.RAMC.ramC[14] !== 18'd542)
        $fatal(1, "C[3][2] failed.");

    if (dut.RAMC.ramC[15] !== 18'd600)
        $fatal(1, "C[3][3] failed.");

    $display("All single-MAC matrix multiplication tests passed.");
    #20;
    $finish;
end

endmodule