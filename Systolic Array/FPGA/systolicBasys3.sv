module systolicBasys3 #(
    parameter int N = 2,
    parameter int SUM_WIDTH = 16 + $clog2(N)
)(
    input  logic clk,
    input  logic reset,
    input  logic start,

    output logic [15:0] led
);

logic [N-1:0][N-1:0][7:0] matrixA;
logic [N-1:0][N-1:0][7:0] matrixB;

logic done;
logic done_latched;

logic [N-1:0][N-1:0][SUM_WIDTH-1:0] result;
logic [31:0] checksum;

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


// test matrices
generate
    for (genvar row = 0; row < N; row++) begin
        for (genvar col = 0; col < N; col++) begin

            assign matrixA[row][col] = row*N + col + 1;
            assign matrixB[row][col] = row*N + col + 1;

        end
    end
endgenerate


accelerator #(
    .N(N),
    .sum_width(SUM_WIDTH)
) dut (
    .clk(accel_clk),
    .reset(accel_reset),
    .start(start),

    .matrixA(matrixA),
    .matrixB(matrixB),

    .done(done),
    .result(result)
);


// latch done so LED stays on
always_ff @(posedge accel_clk) begin
    if (accel_reset)
        done_latched <= 1'b0;
    else if (done)
        done_latched <= 1'b1;
end


// make results observable
always_comb begin

    checksum = 32'b0;

    for (int row = 0; row < N; row++) begin
        for (int col = 0; col < N; col++) begin

            checksum = checksum ^ result[row][col];

        end
    end

end


assign led[0]    = done_latched;
assign led[15:1] = checksum[14:0];

endmodule