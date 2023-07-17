`timescale 1ns / 1ps
module tb_pll;
    bit clk;
    logic clk_out;
    always #5ns clk<=!clk;
    initial begin
        @(posedge dut.locked);
        #50ns
        $finish;
    end
    pll dut(.*);
endmodule