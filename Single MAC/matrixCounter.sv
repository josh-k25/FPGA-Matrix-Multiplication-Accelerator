module matrixCounter(
    input logic clk,
    input logic clear,
    input logic reset,
    input logic countEnable,

    output logic [2:0] count, 
    output logic lastCount
);

assign lastCount = (count == 4'd3);

always_ff @(posedge clk) begin
    if (reset) begin
        count <= 3'd0;
    end
    else if (clear) begin
        count <= 3'd0;
    end
    else if (countEnable) begin
        count <= count + 3'd1;
    end
end

endmodule