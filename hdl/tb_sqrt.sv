`timescale 1ns / 1ps
module tb_sqrt();
    bit clk,rst=1;
    logic [7:0]A,C,D;
    logic [3:0]B;
    assign C=B*B;           //for assertion
    assign D=(B+1)*(B+1);   //for assertion
    always #5ns clk<=!clk;
    initial begin
        #10ns
        rst<=0;
        A<=$urandom;
        repeat(5)@(posedge clk);
        $display("sqrt(%d)=%d\n",A,B);
        assert((C<=A)&&((D>A)))$display("PASS");else $display("FAIL");
        $finish;
    end
    pipe_sqrt dut(.*);
endmodule