// Stochastic number generator, including RNG source

module SNG_RO
    (
        input clk,
        input reset,
        input enable,
        input [7:0] prob,       // k-bit unsigned binary integer B indicating probability
        output stoch_num
    );

    // registers
    reg bit_stream_ff;
    wire [7:0] rand_num;

    // RO_RNG
    RO_PUF_2 rng(
        .clk                    (clk),
        .reset                  (reset),
        .enable                 (enable),
        .rand_num               (rand_num)
    );

    // Comparator, R < B => 1, else 0
    always @(*) begin
        if (rand_num < prob)
            bit_stream_ff = 1'b1;
        else
            bit_stream_ff = 1'b0;
    end

    assign stoch_num = bit_stream_ff;

endmodule