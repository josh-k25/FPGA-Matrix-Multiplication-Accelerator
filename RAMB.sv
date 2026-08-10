module RAMB(
    input logic clk,
    input logic writeEnable,
    input logic [3:0] address,
    input logic [15:0] dataIn,

    output logic [15:0] dataOut
);

logic [15:0] ramB [0:15];

always_ff @(posedge clk) begin
    if (writeEnable)
        ramB[address] <= dataIn;
    
    else 
        dataOut = ramB[address];
end

endmodule