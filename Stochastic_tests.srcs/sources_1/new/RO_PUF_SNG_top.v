
module RO_PUF_SNG_top(
    input clk
    );

    // VIO outputs
    wire reset;
    wire enable;
    wire [7:0] prob;
    // ILA inputs
    wire [7:0] rand_num;
    // Wires
    wire [7:0] bin_num_out;
    wire done;
    wire stoch_bitstr;

    // RO_SNG
    SNG_RO sng(
        .clk                (clk),
        .reset              (reset),
        .enable             (enable),
        .prob               (prob),
        .stoch_num          (stoch_bitstr)
    );

    // STB
    StochToBin stb(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (stoch_bitstr),
        .bin_number         (bin_num_out),
        .done               (done)
    );

    // VIO
    vio_1 vio(
        .clk                (clk),
        .probe_out0         (reset),
        .probe_out1         (enable),
        .probe_out2         (prob)
    );

    // ILA
    ila_1 ila(
        .clk                (clk),
        .probe0             (reset),
        .probe1             (stoch_bitstr),
        .probe2             (bin_num_out)
    );


endmodule
