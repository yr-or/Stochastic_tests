// Test Galois LFSR SNG with bipoalr multiplier

module Mult_test(
    input clk
    );

    // wires
    wire reset;
    wire enable;
    wire [7:0] prob1;
    wire [7:0] prob2;

    // RO PUF wires
    wire ro_stoch1;
    wire ro_stoch2;
    wire ro_mult_out;
    wire [7:0] ro_mult_bin;
    wire done_stb_ro;

    // LFSR SNG wire
    wire lfsr_stoch1;
    wire lfsr_stoch2;
    wire lfsr_mult_out;
    wire [7:0] lfsr_mult_bin;
    wire done_stb_lfsr;

    // VIO
    vio_1 vio(
        .clk                (clk),
        .probe_out0         (reset),
        .probe_out1         (enable),
        .probe_out2         (prob1),
        .probe_out3         (prob2)
    );

    // RO_SNG 1
    SNG_RO ro_sng1(
        .clk                (clk),
        .reset              (reset),
        .enable             (enable),
        .prob               (prob1),
        .stoch_num          (ro_stoch1)
    );

    // RO_SNG 2
    SNG_RO ro_sng2(
        .clk                (clk),
        .reset              (reset),
        .enable             (enable),
        .prob               (prob2),
        .stoch_num          (ro_stoch2)
    );

    // Mult 1
    Mult_bipolar mu1(
        .stoch_num1         (ro_stoch1),
        .stoch_num2         (ro_stoch2),
        .stoch_res          (ro_mult_out)
    );

    // STB RO PUF
    StochToBin stb1(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (ro_mult_out),
        .bin_number         (ro_mult_bin),
        .done               (done_stb_ro)
    );

    // LFSR SNG 1
    StochNumGen lfsr_sng1(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd84),
        .prob               (prob1),
        .stoch_num          (lfsr_stoch1)
    );
    StochNumGen lfsr_sng2(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd113),
        .prob               (prob2),
        .stoch_num          (lfsr_stoch2)
    );

    // lfsr mult
    Mult_bipolar mu2(
        .stoch_num1         (lfsr_stoch1),
        .stoch_num2         (lfsr_stoch2),
        .stoch_res          (lfsr_mult_out)
    );

    // stb lfsr
    StochToBin stb2(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (lfsr_mult_out),
        .bin_number         (lfsr_mult_bin),
        .done               (done_stb_lfsr)
    );

    // ILA
    ila_1 ila(
        .clk                (clk),
        .probe0             (reset),
        .probe1             (done_stb_ro),
        .probe2             (done_stb_lfsr),
        .probe3             (ro_mult_bin),
        .probe4             (lfsr_mult_bin)
    );

endmodule
