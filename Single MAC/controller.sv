module controller(
    input logic clk,
    input logic reset,
    input logic start,
    input logic lastCol,
    input logic lastRow,
    input logic lastK,

    output logic accumulatorEnable,
    output logic accumulatorClear,
    output logic rowCount,
    output logic rowClear,
    output logic colCount,
    output logic colClear,
    output logic kCount,
    output logic kClear,
    output logic CWriteEnable,
    output logic done
);

typedef enum logic [2:0] {
    IDLE,

    PREP,
    CALCULATE,
    WRITE,
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
    nextState = currentState;
    accumulatorEnable = 1'b0;
    accumulatorClear = 1'b0;
    rowCount = 1'b0;
    rowClear = 1'b0;
    colCount = 1'b0;
    colClear = 1'b0;
    kCount = 1'b0;
    kClear = 1'b0;
    CWriteEnable = 1'b0;
    done = 1'b0;

    case (currentState)
        IDLE: begin
            accumulatorEnable = 1'b0;
            accumulatorClear = 1'b0;
            rowCount = 1'b0;
            rowClear = 1'b0;
            colCount = 1'b0;
            colClear = 1'b0;
            kCount = 1'b0;
            kClear = 1'b0;
            CWriteEnable = 1'b0;
            done = 1'b0;    

            if (start == 1'b1) 
                nextState = PREP;
            else 
                nextState = IDLE;
        end

        //reset accumulator
        PREP: begin
            accumulatorEnable = 1'b0;
            accumulatorClear = 1'b1;
            rowCount = 1'b0;
            rowClear = 1'b0;
            colCount = 1'b0;
            colClear = 1'b0;
            kCount = 1'b0;
            kClear = 1'b0;
            CWriteEnable = 1'b0;
            done = 1'b0;  

            nextState = CALCULATE;
        end

        CALCULATE: begin
            accumulatorEnable = 1'b1;
            accumulatorClear = 1'b0;
            rowCount = 1'b0;
            rowClear = 1'b0;
            colCount = 1'b0;
            colClear = 1'b0;
            kCount = 1'b1;
            kClear = 1'b0;
            CWriteEnable = 1'b0;
            done = 1'b0;

            if (lastK == 0)
                nextState = CALCULATE;
            else if (lastK == 1) begin  
                nextState = WRITE;
                kCount = 1'b0;
                kClear = 1'b1;
            end
        end

        WRITE: begin
            accumulatorEnable = 1'b0;
            accumulatorClear = 1'b0;
            rowCount = 1'b0;
            rowClear = 1'b0;
            colCount = 1'b0;
            colClear = 1'b0;
            kCount = 1'b0;
            kClear = 1'b0;
            CWriteEnable = 1'b1;
            done = 1'b0;

            if (lastCol && lastRow)
                nextState = DONE;
            else if (lastCol) begin
                rowCount = 1'b1;
                colClear = 1'b1;
                nextState = PREP;
            end
            else begin
                colCount = 1'b1;
                nextState = PREP;
            end
        end

        DONE: begin
            accumulatorEnable = 1'b0;
            accumulatorClear = 1'b0;
            rowCount = 1'b0;
            rowClear = 1'b1;
            colCount = 1'b0;
            colClear = 1'b1;
            kCount = 1'b0;
            kClear = 1'b1;
            CWriteEnable = 1'b0;
            done = 1'b1;

            nextState = IDLE;
        end
    endcase
end

endmodule



