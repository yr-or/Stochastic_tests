// TB for Mult_test hardware SC multiplier

module Mult_test_tb();

    // regs
    reg clk = 0;
    reg reset;
    // Wires
    wire SNG_a_out;
    wire SNG_b_out;
    wire mult_out;
    wire stb_done;
    wire [7:0] prod;
    // Regs
    reg [7:0] num1 = 8'd192;         // 0.5 bipolar
    reg [7:0] num2 = 8'd96;          // -0.25 bipolar
    // Result should = 0.5*-0.25=-0.125 = 112 Int

    // SNGs
    StochNumGen SNG_a(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd84),
        .prob               (num1),
        .stoch_num          (SNG_a_out)
    );
    StochNumGen SNG_b(
        .clk                (clk),
        .reset              (reset),
        .seed               (8'd113),
        .prob               (num2),
        .stoch_num          (SNG_b_out)
    );

    // Multiplier
    Mult_bipolar mu(
        .stoch_num1         (SNG_a_out),
        .stoch_num2         (SNG_b_out),
        .stoch_res          (mult_out)
    );

    // STB
    StochToBin stb(
        .clk                (clk),
        .reset              (reset),
        .bit_stream         (mult_out),
        .bin_number         (prod),
        .done               (stb_done)
    );

    initial begin
        reset = 1;
        #40;
        reset = 0;
        #100;
    end

    always begin
        #10;
        clk = ~clk;
    end


endmodule
