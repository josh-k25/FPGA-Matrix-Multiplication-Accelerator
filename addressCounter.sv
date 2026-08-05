module addressCounter(
    input logic clk,
    input logic addressEnable,
    input logic addressReset,

    output logic lastAddress,
    output logic [31:0] address
);

always_ff @(posedge clk) begin
    if (addressReset)
        address <= 32'b0;
    else if (addressEnable)
        address <= address + 32'd4;
end

assign lastAddress = (address == 32'd60);

endmodule
