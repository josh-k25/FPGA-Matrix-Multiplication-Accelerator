module systolicController (
    input logic clk,
    input logic reset,
    input logic start,
    input logic lastK,
    input logic lastDrain,

    output logic clear,
    output logic feedValid,
    output logic kCount,
    output logic kClear,
    output logic drainCount,
    output logic drainClear,
    output logic done
);

typedef enum logic [2:0] {
    IDLE,
    CLEAR_STATE,
    FEED,
    DRAIN,
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

always_comb begin
    clear = 1'b0;
    feedValid = 1'b0;
    kClear = 1'b0;
    kCount = 1'b0;
    drainCount = 1'b0;
    drainClear = 1'b0;
    done = 1'b0;
    nextState = currentState;

    case (currentState)
        IDLE: begin
            clear = 1'b0;
            feedValid = 1'b0;
            kClear = 1'b0;
            kCount = 1'b0;
            drainCount = 1'b0;
            drainClear = 1'b0;
            done = 1'b0;

            if (start)
                nextState = CLEAR_STATE;
            else 
                nextState = IDLE;

        end

        CLEAR_STATE: begin
            clear = 1'b1;
            feedValid = 1'b0;
            kClear = 1'b1;
            kCount = 1'b0;
            drainCount = 1'b0;
            drainClear = 1'b1;
            done = 1'b0;
            
            nextState = FEED;
        end

        FEED: begin
            clear = 1'b0;
            feedValid = 1'b1;
            kClear = 1'b0;
            drainCount = 1'b0;
            drainClear = 1'b0;
            done = 1'b0;
            
            if (lastK) begin
                nextState = DRAIN;
                kCount = 1'b0;
            end
            else begin
                kCount = 1'b1;
                nextState = FEED; 
            end
        end

        DRAIN: begin
            clear = 1'b0;
            feedValid = 1'b0;
            kClear = 1'b0;
            kCount = 1'b0;
            drainClear = 1'b0;
            done = 1'b0;

            if (lastDrain) begin
                nextState = DONE;
                drainCount = 1'b0;
            end
            else begin
                nextState = DRAIN;
                drainCount = 1'b1;
            end
        end

        DONE: begin
            clear = 1'b0;
            feedValid = 1'b0;
            kClear = 1'b0;
            kCount = 1'b0;
            drainCount = 1'b0;
            drainClear = 1'b0;
            done = 1'b1;
            

            nextState = IDLE;
        end
    endcase
end
endmodule