module RAMB(
    input logic clk,
    input logic writeEnable,
    input logic [3:0] address,
    input logic [7:0] dataIn,

    output logic [7:0] dataOut
);

logic [7:0] ramB [0:15];

initial begin
    ramB[0]  = 8'd1;
    ramB[1]  = 8'd2;
    ramB[2]  = 8'd3;
    ramB[3]  = 8'd4;

    ramB[4]  = 8'd5;
    ramB[5]  = 8'd6;
    ramB[6]  = 8'd7;
    ramB[7]  = 8'd8;

    ramB[8]  = 8'd9;
    ramB[9]  = 8'd10;
    ramB[10] = 8'd11;
    ramB[11] = 8'd12;

    ramB[12] = 8'd13;
    ramB[13] = 8'd14;
    ramB[14] = 8'd15;
    ramB[15] = 8'd16;
end

always_ff @(posedge clk)
    if (writeEnable)
        ramB[address] <= dataIn;

assign dataOut = ramB[address];


endmodule