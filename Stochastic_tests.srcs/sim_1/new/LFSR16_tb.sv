`timescale 1ns / 1ps
// Test 4-bit LFSR

module LFSR16_tb();

    reg clk = 0;
    wire [15:0] lfsr_out;
    reg [15:0] seed = 16'd3938;
    reg reset = 0;

    // instantiate dut
    LFSR16 dut(
        .clk                (clk),
        .reset              (reset),
        .seed               (seed),
        .parallel_out       (lfsr_out)
    );

    always begin
        #10;
        clk = ~clk;
    end

endmodule