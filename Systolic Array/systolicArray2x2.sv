module systolicArray2x2(
    input logic clk,
    input logic reset,
    input logic clear,
    input logic [7:0] dataInA0,
    input logic [7:0] dataInA1,
    input logic [7:0] dataInB0,
    input logic [7:0] dataInB1,
    input logic AValidIn0,
    input logic AValidIn1,
    input logic BValidIn0,
    input logic BValidIn1,

    output logic [17:0] sum00,
    output logic [17:0] sum01,
    output logic [17:0] sum10,
    output logic [17:0] sum11
);

logic [7:0] A00to01;
logic AValid00to01;
logic [7:0] A10to11;
logic AValid10to11;
logic [7:0] B00to10;
logic BValid00to10;
logic [7:0] B01to11;
logic BValid01to11;

processingElement PE00(
    .clk(clk),
    .clear(clear),
    .reset(reset),
    .dataInA(dataInA0),
    .dataInB(dataInB0),
    .AValidIn(AValidIn0),
    .BValidIn(BValidIn0),
    .dataOutA(A00to01),
    .dataOutB(B00to10),
    .AValidOut(AValid00to01),
    .BValidOut(BValid00to10),
    .sum(sum00)
);

processingElement PE01(
    .clk(clk),
    .clear(clear),
    .reset(reset),
    .dataInA(A00to01),
    .dataInB(dataInB1),
    .AValidIn(AValid00to01),
    .BValidIn(BValidIn1),
    .dataOutA(),
    .dataOutB(B01to11),
    .AValidOut(),
    .BValidOut(BValid01to11),
    .sum(sum01)
);

processingElement PE10(
    .clk(clk),
    .clear(clear),
    .reset(reset),
    .dataInA(dataInA1),
    .dataInB(B00to10),
    .AValidIn(AValidIn1),
    .BValidIn(BValid00to10),
    .dataOutA(A10to11),
    .dataOutB(),
    .AValidOut(AValid10to11),
    .BValidOut(),
    .sum(sum10)
);

processingElement PE11(
    .clk(clk),
    .clear(clear),
    .reset(reset),
    .dataInA(A10to11),
    .dataInB(B01to11),
    .AValidIn(AValid10to11),
    .BValidIn(BValid01to11),
    .dataOutA(),
    .dataOutB(),
    .AValidOut(),
    .BValidOut(),
    .sum(sum11)
);

endmodule