module accumulator(
    input logic clk,
    input logic accumulatorClear,
    input logic accumulatorEnable,
    input logic reset,
    input logic [15:0] product,

    //18 bits since 8 bit x 8 bit is 16 bits and sum needs to hold 4 x 16 bits 
    output logic [17:0] sum
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        sum <= 18'd0;
    else if (accumulatorClear)
        sum <= 18'd0;
    else if (accumulatorEnable)
        sum <= sum + product;
end 

endmodule