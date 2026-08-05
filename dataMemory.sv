module addressCounter(
    input logic clk,

    output logic [31:0] address
);

logic [31:0] registerArray [0:127];
address = 32'd0;

always_ff @(posedge clk) begin
    address <= address + 32'd4;
end

endmodule
