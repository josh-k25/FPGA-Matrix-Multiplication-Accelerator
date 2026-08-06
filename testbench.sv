`timescale 1ns/1ps

module testbench;

logic clk;
logic reset;
logic start;

logic done;
logic [31:0] result;

datapath dut(
    clk,
    reset,
    start,

    done,
    result
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;
    #1;

    @(posedge clk);
    #1;

    //fsm should now be at idle
    if (dut.controller.currentState !== 3'd0)
        $fatal(1, "Initial IDLE failed");
    
    reset = 0;
    start = 1;
    #1;

    @(posedge clk);
    #1;

    //fsm should be at first load
    if (dut.controller.currentState !== 3'd1)
        $fatal(1, "Initial LOAD failed");

    start = 0;
    
    if (dut.address !== 32'd0)
        $fatal(1, "Address counter edge 1 failed");

    if (dut.controller.writeEnable !== 1'd1)
        $fatal(1, "writeEnable for edge 1 failed");

    @(posedge clk);
    #1;
    //fsm should be at second load
    if(dut.dataMemory.address !== 32'd4)
        $fatal(1, "Address counter edge 2 failed");

    if (dut.controller.writeEnable !== 1'd1)
        $fatal(1, "writeEnable for edge 2 failed");
    
    if (dut.dataMemory.memory[0] !== 0)
        $fatal(1, "writeData for edge 2 failed.");

    @(posedge clk);
    #1;
    //fsm should be at third load
    if(dut.dataMemory.address !== 32'd8)
        $fatal(1, "Address counter edge 3 failed");

    if (dut.controller.writeEnable !== 1'd1)
        $fatal(1, "writeEnable for edge 3 failed");
    
    if (dut.dataMemory.memory[1] !== 1)
        $fatal(1, "writeData for edge 3 failed.");

    wait (dut.address == 32'd60);
    #1;

    if (dut.writeData !== 32'd15)
        $fatal(1, "Expected writeData 15");

    //fms should be at PREP for one rising edge
    @(posedge clk);
    #1;

    if (dut.controller.currentState !== 3'd2)
        $fatal(1, "Initial PREP failed");

    if (dut.controller.accumulatorClear !== 1'b1)
        $fatal(1, "PREP Accumulator Clear failed.");

    //fsm should be at accumulator and loop until it hits the final address
    //memory[0] should be added to the sum since it was already being read last rising edge from PREP's address reset
    //memory[1] is next in line to be added --> currently being read
    @(posedge clk);
    #1;

    if (dut.controller.accumulatorEnable !== 1'b1)
        $fatal(1, "ACCUMULATE accumulator enable failed.");

    if (dut.readData !== 32'd0)
        $fatal(1, "ACCUMULATE readData failed (0).");

    if (dut.result !== 32'd0)
        $fatal(1, "ACCUMULATE sum failed (0)");

    //added 0 previously
    // 1 is being added so sum is 1
    // 2 is being read
    @(posedge clk);
    #1;

    if (dut.readData !== 32'd1)
        $fatal(1, "ACCUMULATE readData failed (1).");

    if (dut.result !== 32'd0)
        $fatal(1, "ACCUMLATE sum failed (0)");

    //1 added previously
    // 2 is being added so sum is 3
    // 3 is being read
    @(posedge clk);
    #1;

    if (dut.readData !== 32'd2)
        $fatal(1, "ACCUMULATE readData failed (2).");

    if (dut.result !== 32'd1)
        $fatal(1, "ACCUMLATE sum failed (1)");

    // 2 added previously
    // 3 is being aded so sum is 6
    // 4 is being read
    @(posedge clk);
    #1;

    if (dut.readData !== 32'd3)
        $fatal(1, "ACCUMULATE readData failed (3).");

    if (dut.result !== 32'd3)
        $fatal(1, "ACCUMLATE sum failed (3)");

    // 3 added previously
    // 4 is being added so sum is 10
    // 5 is being read
    @(posedge clk);
    #1;

    if (dut.readData !== 32'd4)
        $fatal(1, "ACCUMULATE readData failed (4).");

    if (dut.result !== 32'd6)
        $fatal(1, "ACCUMLATE sum failed (6)");

    wait (dut.address == 32'd60);
    #1;

    @(posedge clk);
    #1;

    //fsm should be at FINAL for one rising edge
    if (dut.controller.currentState !== 3'd4)
        $fatal(1, "FINAL state failed (0).");

    @(posedge clk);
    #1;

    //fsm should be at DONE now for 1 rising edge
    if (dut.controller.currentState !== 3'd5 )
        $fatal(1, "FINAL done failed.");

    @(posedge clk);
    #1;

    //should be at IDLE now
    if (dut.controller.currentState !== 3'd0)
        $fatal(1, "IDLE after FINAL failed.");
        

    @(posedge clk);
    #1;

    if (dut.controller.currentState !== 3'd0)
        $fatal(1, "IDLE after IDLE failed.");
    
    $display("All tests passed.");
    $finish;
    
end

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, testbench);
end

endmodule




