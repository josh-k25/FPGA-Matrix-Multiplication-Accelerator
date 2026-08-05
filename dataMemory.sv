module dataMemory(
    input logic clk,
    input logic writeEnable,
    input logic [31:0] writeData,
    input logic [31:0] address,

    output logic [31:0] readData
);

logic [31:0] memory [0:255];

always_ff @(posedge clk) begin
    if (writeEnable)
        memory[address[9:2]] <= writeData;

    else
        readData <= memory[address[9:2]] ;
end
endmodule