module processingElement (
    input logic clk,
    input logic clear,
    input logic reset,
    input logic [7:0] dataInA,
    input logic [7:0] dataInB,
    input logic AValidIn,
    input logic BValidIn,
    
    output logic [7:0] dataOutA,
    output logic [7:0] dataOutB,
    output logic AValidOut,
    output logic BValidOut,
    output logic [17:0] sum
);

always_ff @(posedge clk) begin

    if (reset) begin
        sum <= 18'b0;
    end
    else if (clear) begin
        sum <= 18'b0;
    end
    else if (AValidIn && BValidIn) begin
        sum <= sum + (dataInA * dataInB);
    end

    if (reset) begin
        dataOutA <= 8'b0;
        dataOutB <= 8'b0;
        AValidOut <= 1'b0;
        BValidOut <= 1'b0;
    end
    else begin
        dataOutA <= dataInA;
        dataOutB <= dataInB;
        AValidOut <= AValidIn;
        BValidOut <= BValidIn;
    end
end

endmodule


