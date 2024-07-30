// Hardware testbench for testing LFSR SNG with mutliplier

module LFSR_SNG_mult_test(
    input clk
    );

    localparam NUM_TESTS = 50;

    // wires
    wire reset;
    wire enable;
    wire done [0:NUM_TESTS-1];

    wire [7:0] mul_out [0:NUM_TESTS-1];

    // stoch wires
    wire num1_stoch [0:NUM_TESTS-1];
    wire num2_stoch [0:NUM_TESTS-1];
    wire mul_out_stoch [0:NUM_TESTS-1];

    // Inputs
    reg [7:0] num1_tests [0:NUM_TESTS-1] = '{163, 149, 98, 109, 131, 46, 183, 22, 243, 121, 151, 186, 152, 9, 131, 208, 207, 111, 105, 179, 165, 156, 149, 218, 175, 125, 188, 187, 86, 49, 215, 95, 241, 196, 245, 187, 66, 172, 162, 75, 161, 168, 141, 121, 205, 46, 160, 0, 63, 129};
    reg [7:0] num2_tests [0:NUM_TESTS-1] = '{10, 241, 139, 249, 142, 98, 3, 33, 178, 242, 115, 127, 231, 171, 179, 132, 32, 15, 128, 2, 222, 49, 249, 6, 110, 54, 83, 213, 151, 171, 52, 174, 217, 149, 132, 11, 190, 194, 228, 70, 69, 159, 48, 225, 153, 5, 85, 133, 208, 254};

    // SNG seeds
    reg [7:0] SNG1_seeds [0:NUM_TESTS-1] = '{226, 110, 107, 86, 80, 69, 13, 200, 15, 158, 138, 55, 132, 231, 138, 26, 131, 39, 181, 92, 218, 157, 99, 72, 71, 171, 51, 35, 230, 194, 254, 253, 175, 127, 119, 123, 26, 97, 132, 164, 234, 48, 41, 205, 34, 216, 143, 229, 212, 91};
    reg [7:0] SNG2_seeds [0:NUM_TESTS-1] = '{23, 131, 203, 204, 109, 161, 242, 184, 33, 219, 207, 197, 183, 38, 164, 226, 19, 147, 68, 120, 186, 71, 101, 16, 166, 123, 102, 187, 94, 53, 242, 18, 60, 156, 237, 127, 101, 230, 33, 116, 176, 148, 83, 34, 41, 161, 37, 165, 247, 70};

    // SNG 1
    genvar i;
    generate
        for (i=0; i<NUM_TESTS; i=i+1) begin
            StochNumGen sng1(
                .clk                (clk),
                .reset              (reset),
                .seed               (SNG1_seeds[i]),
                .prob               (num1_tests[i]),
                .stoch_num          (num1_stoch[i])
            );
        end
    endgenerate

    // SNG 1   
    generate
        for (i=0; i<NUM_TESTS; i=i+1) begin
            StochNumGen sng2(
                .clk                (clk),
                .reset              (reset),
                .seed               (SNG2_seeds[i]),
                .prob               (num2_tests[i]),
                .stoch_num          (num2_stoch[i])
            );
        end
    endgenerate

    // Mult
    generate
        for (i=0; i<NUM_TESTS; i=i+1) begin
            Mult_bipolar mu (
                .stoch_num1             (num1_stoch[i]),
                .stoch_num2             (num2_stoch[i]),
                .stoch_res              (mul_out_stoch[i])
            );
        end
    endgenerate

    // STB mul res
    generate
        for (i=0; i<NUM_TESTS; i=i+1) begin
            StochToBin stb_mul(
                .clk                (clk),
                .reset              (reset),
                .bit_stream         (mul_out_stoch[i]),
                .bin_number         (mul_out[i]),
                .done               (done[i])
            );
        end
        endgenerate

    // VIO
    vio_2 vio(
        .clk                (clk),
        .probe_out0         (reset),
        .probe_out1         (enable)
    );

    // ILA
    ila_2 ila_mult(
        .clk                (clk),
        .probe0             (reset),
        .probe1             (done[0]),
        .probe2             (mul_out[0]),
        .probe3             (mul_out[1]),
        .probe4             (mul_out[2]),
        .probe5             (mul_out[3]),
        .probe6             (mul_out[4]),
        .probe7             (mul_out[5]),
        .probe8             (mul_out[6]),
        .probe9             (mul_out[7]),
        .probe10             (mul_out[8]),
        .probe11             (mul_out[9]),
        .probe12             (mul_out[10]),
        .probe13             (mul_out[11]),
        .probe14             (mul_out[12]),
        .probe15             (mul_out[13]),
        .probe16             (mul_out[14]),
        .probe17             (mul_out[15]),
        .probe18             (mul_out[16]),
        .probe19             (mul_out[17]),
        .probe20             (mul_out[18]),
        .probe21             (mul_out[19]),
        .probe22             (mul_out[20]),
        .probe23             (mul_out[21]),
        .probe24             (mul_out[22]),
        .probe25             (mul_out[23]),
        .probe26             (mul_out[24]),
        .probe27             (mul_out[25]),
        .probe28             (mul_out[26]),
        .probe29             (mul_out[27]),
        .probe30             (mul_out[28]),
        .probe31             (mul_out[29]),
        .probe32             (mul_out[30]),
        .probe33             (mul_out[31]),
        .probe34             (mul_out[32]),
        .probe35             (mul_out[33]),
        .probe36             (mul_out[34]),
        .probe37             (mul_out[35]),
        .probe38             (mul_out[36]),
        .probe39             (mul_out[37]),
        .probe40             (mul_out[38]),
        .probe41             (mul_out[39]),
        .probe42             (mul_out[40]),
        .probe43             (mul_out[41]),
        .probe44             (mul_out[42]),
        .probe45             (mul_out[43]),
        .probe46             (mul_out[44]),
        .probe47             (mul_out[45]),
        .probe48             (mul_out[46]),
        .probe49             (mul_out[47]),
        .probe50             (mul_out[48]),
        .probe51             (mul_out[49])
    );

endmodule
