
module ReLU_FSM_top(
    input clk_a,
    input clk_b,
    input reset,
    input [7:0] inp_prob,
    input [7:0] seed,
    output [7:0] out_prob
    );

    // Wires
    wire inp_stoch;
    wire out_stoch;
    wire done_stb;

    // Generate stochastic number
    StochNumGen SNG1(
        .clk                (clk_a),
        .reset              (reset),
        .seed               (seed),
        .prob               (inp_prob),
        .stoch_num          (inp_stoch)
    );

    // Apply stoch input to FSM
    ReLU_FSM FSM(
        .clk                (clk_b),
        .reset              (reset),
        .in_stoch           (inp_stoch),
        .out_stoch          (out_stoch)
    );

    // Estimate probability of output
    StochToBin stb(
        .clk                (clk_b),
        .reset              (reset),
        .bit_stream         (out_stoch),
        .bin_number         (out_prob),
        .done               (done_stb)
    );  

endmodule
