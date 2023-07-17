`timescale 1ns / 1ps
module tb_div();
    bit clk,rst=1;
    logic [7:0]A,C;
    logic [3:0]B;
    always #5ns clk<=!clk;
    initial begin
        #10ns
        rst<=0;
        A<=$urandom;
        B<=$urandom;
        repeat(9)@(posedge clk);
        $display("A=%d, B=%d, A/B=C=%d\n",A,B,C);
        assert(C==A/B)$display("PASS");else $display("FAIL");
        $finish;
    end
    pipe_div dut(.*);
endmodule
