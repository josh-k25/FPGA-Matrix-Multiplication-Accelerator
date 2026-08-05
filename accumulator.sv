module accumulator(
    input logic accumulateEnable,
    input logic reset,
    input logic [31:0] data,

    output logic [31:0] sum
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        sum <= 32'd0;
    else 
    sum <= sum + data;
end 

endmodule