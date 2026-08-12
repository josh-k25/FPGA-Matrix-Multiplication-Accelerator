module multiplier(
    input logic [7:0] dataA,
    input logic [7:0] dataB,

    output logic [15:0] result
);

assign result = dataA * dataB;

endmodule