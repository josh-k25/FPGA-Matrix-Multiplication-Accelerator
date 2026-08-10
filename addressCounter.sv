module addressCounter(
    input logic clk,
    input logic reset,
    input logic addressEnable,
    input logic addressReset,

    output logic lastAddress,
    output logic [3:0] address,
    output logic [1:0] row,
    output logic [1:0] col
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        address <= 4'd0;
    else if (addressReset)
        address <= 4'd0;
    else if (addressEnable)
        address <= address + 4'd1;
end

assign lastAddress = (address == 4'd16);

assign row = address[3:2];
assign col = address[1:0];

endmodule
