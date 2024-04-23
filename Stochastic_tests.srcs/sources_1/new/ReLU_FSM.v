// Activation function implemented with FSM
// Reference: W. Gross book pg. 72

// Inputs: stochastic number x
// outputs: stochastic number y
module ReLU_FSM(
    input clk,
    input reset,
    input in_stoch,
    output out_stoch
    );

    // FSM States
    parameter STATE0 = 3'b000;
    parameter STATE1 = 3'b001;
    parameter STATE2 = 3'b010;
    parameter STATE3 = 3'b011;
    parameter STATE4 = 3'b100;
    parameter STATE5 = 3'b101;  // Output 1 for this state only

    // State variables
    reg [2:0] state_ff;        // 6 states
    reg [2:0] next_state;

    // Internal wires / regs
    reg SN_out;
    reg SN_out_ff;

    // Sequential logic for going to next state
    always @(posedge clk) begin
        if (reset) begin
            state_ff <= STATE2;
        end else begin
            state_ff <= next_state;
        end
    end

    // Combinational logic for states
    always @(*) begin
        case(state_ff)
            STATE0 : begin
                SN_out = 0;                 // Output always 0 when state < 5
                if (in_stoch)
                    next_state = STATE2;
                else
                    next_state = STATE0;
            end
            STATE1 : begin
                SN_out = 0;
                if (in_stoch)
                    next_state = STATE3;
                else
                    next_state = STATE0;
            end
            STATE2 : begin
                SN_out = 0;
                if (in_stoch)
                    next_state = STATE4;
                else
                    next_state = STATE1;
            end
            STATE3 : begin
                SN_out = 0;
                if (in_stoch)
                    next_state = STATE5;
                else
                    next_state = STATE1;
            end
            STATE4 : begin
                SN_out = 0;
                if (in_stoch)
                    next_state = STATE5;
                else
                    next_state = STATE2;    // Was STATE3 erroneously
            end
            STATE5 : begin
                SN_out = 1;                 // Output 1 here
                if (in_stoch)
                    next_state = STATE5;
                else
                    next_state = STATE3;
            end
            default : begin     // STATE2
                SN_out = 0;                 // Output always 0 when state < 5
                if (in_stoch)
                    next_state = STATE4;
                else
                    next_state = STATE1;
            end
        endcase
    end

    // Register output
    always @(posedge clk) begin
        if (reset)
            SN_out_ff <= 0;
        else
            SN_out_ff <= SN_out;
    end

    // Assign output
    assign out_stoch = SN_out_ff;

endmodule