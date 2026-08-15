module dataSkewer #(
    parameter int N = 4
)(
    input logic clk,
    input logic reset,

    input logic [7:0] rawA [0:N-1],
    input logic [7:0] rawB [0:N-1],

    input logic rawAValid [0:N-1],
    input logic rawBValid [0:N-1],

    output logic [7:0] skewedA [0:N-1],
    output logic [7:0] skewedB [0:N-1],

    output logic skewedAValid [0:N-1],
    output logic skewedBValid [0:N-1]
);

logic [7:0] A_delay [0:N-1][0:N-1];
logic [7:0] B_delay [0:N-1][0:N-1];

logic AValid_delay [0:N-1][0:N-1];
logic BValid_delay [0:N-1][0:N-1];

genvar lane;

generate
    for (lane = 0; lane < N; lane = lane + 1) begin : lane
        if (lane == 0) begin
            //lane 0 no delay
            assign skewedA[lane] = rawA[lane];
            assign skewedB[lane] = rawB[lane];

            assign skewedAValid[lane] = rawAValid[lane];
            assign skewedBValid[lane] = rawBValid[lane];
        end
        else begin

            always_ff @(posedge clk) begin
                if (reset) begin
                    //stage represents how far a value has progressed through a lane's delay chain
                    for (int stage = 0; stage < lane; stage = stage + 1) begin
                        A_delay[lane][stage] <= '0;
                        B_delay[lane][stage] <= '0;

                        AValid_delay[lane][stage] <= 1'b0;
                        BValid_delay[lane][stage] <= 1'b0;
                    end

                end
                else begin
                    //first delay register gets new input
                    A_delay[lane][0] <= rawA[lane];
                    B_delay[lane][0] <= rawB[lane];

                    AValid_delay[lane][0] <= rawAValid[lane];
                    BValid_delay[lane][0] <= rawBValid[lane];

                    //shift data through remaining delay registers
                    for (int stage = 1; stage < lane; stage = stage + 1) begin
                        A_delay[lane][stage] <= A_delay[lane][stage-1];
                        B_delay[lane][stage] <= B_delay[lane][stage-1];

                        AValid_delay[lane][stage] <= AValid_delay[lane][stage-1];
                        BValid_delay[lane][stage] <= BValid_delay[lane][stage-1];
                    end

                end
            end

            //output comes from final delay stage
            assign skewedA[lane] = A_delay[lane][lane-1];
            assign skewedB[lane] = B_delay[lane][lane-1];

            assign skewedAValid[lane] = AValid_delay[lane][lane-1];
            assign skewedBValid[lane] = BValid_delay[lane][lane-1];

        end
    end

endgenerate

endmodule

