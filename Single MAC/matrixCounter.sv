module matrixCounter #(
    parameter int N = 4,
    parameter int WIDTH = $clog2(N)
    )(
    input logic clk,
    input logic clear,
    input logic reset,
    input logic countEnable,

    output logic [WIDTH - 1:0] count, 
    output logic lastCount
);

assign lastCount = (count == N-1);

always_ff @(posedge clk) begin
    if (reset || clear)
        count <= '0;
    else if (countEnable) begin
        if (count == N-1)
            count <= '0;
        else
            count <= count + 1'b1;
    end
end

endmodule