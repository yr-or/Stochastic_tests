// MulAcc module with bipolar values

module MulAcc8_bi(
    input clk,
    input reset,
    input inps_stoch [0:7],         // Bus of 8 stochastic numbers, for inputs 1-8
    input weights_stoch [0:7],
    output result_stoch,
    output mul_res_stoch [0:7],
    output add1_res_stoch [0:3],
    output add2_res_stoch [0:1]
    );

    // results from AND gates
    wire mult_res [0:7];
    wire add1_res [0:3];
    wire add2_res [0:1];

    // TB wires
    assign mul_res_stoch = mult_res;
    assign add1_res_stoch = add1_res;
    assign add2_res_stoch = add2_res;

    // 8 XNOR gates - bipolar multiplication
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin
            Mult_bipolar mu (
                .stoch_num1             (inps_stoch[i]),
                .stoch_num2             (weights_stoch[i]),
                .stoch_res              (mult_res[i])
            );
        end
    endgenerate

    // 1st set of adders - 4
    reg [7:0] LFSR_seeds_add1 [0:3] = '{150, 118, 250, 58};
    generate
        for (i=0; i<4; i=i+1) begin
            Adder add (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_seeds_add1[i]),
                .stoch_num1             (mult_res[i*2]),
                .stoch_num2             (mult_res[(i*2)+1]),
                .result_stoch           (add1_res[i])
            );
        end
    endgenerate
    // 2nd set of adders - 2
    reg [7:0] LFSR_seeds_add2 [0:1] = '{75, 162};
    generate
        for (i=0; i<2; i=i+1) begin
            Adder add (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_seeds_add2[i]),
                .stoch_num1             (add1_res[i*2]),
                .stoch_num2             (add1_res[(i*2)+1]),
                .result_stoch           (add2_res[i])
            );
        end
    endgenerate
    // Last adder - 1 Multiplexer
    Adder add (
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (8'd53),
        .stoch_num1             (add2_res[0]),
        .stoch_num2             (add2_res[1]),
        .result_stoch           (result_stoch)
    );
endmodule