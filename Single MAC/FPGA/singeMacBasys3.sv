module singleMacBasys3 #(
    parameter int N = 4,
    parameter int SUM_WIDTH = 16 + $clog2(N)
)(
    input  logic clk,
    input  logic reset,
    input  logic start,

    output logic [15:0] led
);

logic done;
logic done_latched;

logic [SUM_WIDTH-1:0] result;

logic accel_clk;
logic clk_locked;
logic accel_reset;


clk_wiz_0 clockWizard (
    .clk_in1(clk),
    .reset(reset),

    .clk_out1(accel_clk),
    .locked(clk_locked)
);


assign accel_reset = reset | ~clk_locked;


datapath #(
    .N(N),
    .SUM_WIDTH(SUM_WIDTH)
) dut (
    .clk(accel_clk),
    .reset(accel_reset),
    .start(start),

    .done(done),
    .result(result)
);

always_ff @(posedge accel_clk) begin
    if (accel_reset)
        done_latched <= 1'b0;
    else if (done)
        done_latched <= 1'b1;
end

assign led[0]    = done_latched;
assign led[15:1] = result[14:0];

endmodule