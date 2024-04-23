
module MulAcc_test(
    input clk
    );
    // 8x8 bipolar MulAcc module test
    // 8 SN inputs
    // 8 SN weights

    localparam NUM_INP = 8;

    // Wires
    wire reset;
    wire macc_res_stoch;
    wire mul_res_stoch [0:7];
    wire add1_res_stoch [0:3];
    wire add2_res_stoch [0:1];

    // Wires for STB -> Macc
    wire input_data_stoch [0:7];
    wire input_weights_stoch [0:7];

    // MulAcc8
    MulAcc8_bi macc(
        .clk                    (clk),
        .reset                  (reset),
        .inps_stoch             (input_data_stoch),
        .weights_stoch          (input_weights_stoch),
        .result_stoch           (macc_res_stoch),
        .mul_res_stoch          (mul_res_stoch),
        .add1_res_stoch         (add1_res_stoch),
        .add2_res_stoch         (add2_res_stoch)
    );

    // Binary prob weights vals
    reg [7:0] weights_probs [0:NUM_INP-1] = { 156, 150, 123, 163, 93, 200, 72, 21 };
    reg [7:0] inputs_probs [0:NUM_INP-1] =  { 156, 150, 123, 163, 93, 200, 72, 21 };

    // SNGs for input data and weights
    genvar i;
    generate
        for (i=0; i<NUM_INP; i=i+1) begin
            // 8x8 SNGs for weights
            StochNumGen SNG_wghts(
                .clk                (clk),
                .reset              (reset),
                .seed               (8'd134),       // Changed to single value
                .prob               (weights_probs[i]),
                .stoch_num          (input_weights_stoch[i])
            );
        end
    endgenerate

    generate
        // 8 SNGs for inputs
        for (i=0; i<NUM_INP; i=i+1) begin
            StochNumGen SNG_inps(
                .clk                (clk),
                .reset              (reset),
                .seed               (8'd132),       // Changed from array to single value
                .prob               (inputs_probs[i]),
                .stoch_num          (input_data_stoch[i])
            );
        end
    endgenerate

    // STB for output
    wire [7:0] output_val;
    wire done_stb1;
    StochToBin STB1(
        .clk                        (clk),
        .reset                      (reset),
        .bit_stream                 (macc_res_stoch),
        .bin_number                 (output_val),
        .done                       (done_stb1)
    );

    // ILA
    ila_0 ila(
        .clk                        (clk),
        .probe0                     (output_val),
        .probe1                     (done_stb1),
        .probe2                     (macc_res_stoch),
        .probe3                     (reset),
        .probe4                     (add2_res_stoch[0])
    );

    // VIO
    vio_0 vio(
        .clk                        (clk),
        .probe_out0                 (reset)
    );

endmodule
