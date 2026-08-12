module ROMA(
    input logic [3:0] address,

    output logic [7:0] dataOut
);

logic [7:0] ramA [0:15];

initial begin
    ramA[0]  = 8'd1;
    ramA[1]  = 8'd2;
    ramA[2]  = 8'd3;
    ramA[3]  = 8'd4;

    ramA[4]  = 8'd5;
    ramA[5]  = 8'd6;
    ramA[6]  = 8'd7;
    ramA[7]  = 8'd8;

    ramA[8]  = 8'd9;
    ramA[9]  = 8'd10;
    ramA[10] = 8'd11;
    ramA[11] = 8'd12;

    ramA[12] = 8'd13;
    ramA[13] = 8'd14;
    ramA[14] = 8'd15;
    ramA[15] = 8'd16;
end

assign dataOut = ramA[address];

endmodule