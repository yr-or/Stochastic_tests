// Testbench for STB

module STB_tb();

    reg clk_tb = 1'b0;
    reg reset_tb = 1'b0;
    wire bit_stream_tb;
    wire [7:0] bin_number_tb;
    wire done_tb;

    StochToBin stb(
        .clk                (clk_tb),
        .reset              (reset_tb),
        .bit_stream         (bit_stream_tb),
        .bin_number         (bin_number_tb),
        .done               (done_tb)
    );

    // Add SNG to test
    reg [7:0] num_tb = 8'b10000000;  // 0.5
    StochNumGen SNG1(
        .clk                (clk_tb),
        .reset              (reset_tb),
        .seed               (8'd55),
        .prob               (num_tb),
        .stoch_num          (bit_stream_tb)
    );

    initial begin
        reset_tb = 1;
        #30;
        reset_tb = 0;
        #150;
        #200;
    end

    always begin
        #10;
        clk_tb = ~clk_tb;
    end

endmodule
