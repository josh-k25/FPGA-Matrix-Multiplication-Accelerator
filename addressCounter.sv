module addressCounter(
    input logic clk,
    input logic reset,
    input logic addressEnable,
    input logic addressReset,

    output logic lastAddress,
    output logic [31:0] address
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        address <= 32'd0;
    else if (addressReset)
        address <= 32'd0;
    else if (addressEnable)
        address <= address + 32'd4;
end

assign lastAddress = (address == 32'd60);

endmodule
