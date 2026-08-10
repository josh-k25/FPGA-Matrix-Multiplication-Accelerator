module controllerOld(
    input logic clk,
    input logic reset,
    input logic start,
    input logic lastAddress,

    output logic addressEnable,
    output logic addressReset,
    output logic accumulatorEnable,
    output logic accumulatorClear,
    output logic writeEnable,
    output logic done
);

typedef enum logic [2:0] {
    IDLE,
    LOAD,
    PREP,
    ACCUMULATE,
    FINAL,
    DONE
} stateType;

stateType currentState;
stateType nextState;

always_ff @(posedge clk) begin
    if (reset) 
        currentState <= IDLE;
    else
        currentState <= nextState;
end

//comb logic for state machine
always_comb begin
    nextState = currentState;
    addressEnable = 1'b0;
    addressReset  = 1'b0;
    accumulatorClear = 1'b0;
    accumulatorEnable = 1'b0;
    writeEnable  = 1'b0;
    done  = 1'b0;

    // state machine logic 
    case (currentState)
        //waiting to start
        IDLE: begin
            addressEnable = 1'b0;
            addressReset = 1'b0;
            accumulatorClear = 1'b0;
            accumulatorEnable = 1'b0;
            writeEnable = 1'b0;
            done = 1'b0;

            if (start == 1'b1) 
                nextState = LOAD;
            else 
                nextState = IDLE;
        end

        //loading 0, 1, ... 15
        LOAD: begin
            addressEnable = 1'b1;
            addressReset = 1'b0;
            accumulatorClear = 1'b0;
            accumulatorEnable = 1'b0;
            writeEnable = 1'b1;
            done = 1'b0;

            if (lastAddress) begin
                nextState = PREP;
                addressReset = 1'b1;
            end
            else
                nextState = LOAD;
        end

        //
        PREP: begin
            addressEnable = 1'b1;
            addressReset = 1'b0;
            accumulatorClear = 1'b1;
            accumulatorEnable = 1'b0;
            writeEnable = 1'b0;
            done = 1'b0;

            nextState = ACCUMULATE;
        end

        ACCUMULATE: begin
            addressEnable = 1'b1;
            addressReset = 1'b0;
            accumulatorClear = 1'b0;
            accumulatorEnable = 1'b1;
            writeEnable = 1'b0;
            done = 1'b0;

            if (lastAddress)
                nextState = FINAL;
            else
                nextState = ACCUMULATE;
        end

        FINAL: begin
            addressEnable = 1'b0;
            addressReset = 1'b0;
            accumulatorClear = 1'b0;
            accumulatorEnable = 1'b1;
            writeEnable = 1'b0;
            done = 1'b0;

            nextState = DONE;
        end

        DONE: begin
            addressEnable = 1'b0;
            addressReset = 1'b1;
            accumulatorClear = 1'b0;
            accumulatorEnable = 1'b0;
            writeEnable = 1'b0;
            done = 1'b1;

            nextState = IDLE;
        end
    endcase 
end

endmodule









