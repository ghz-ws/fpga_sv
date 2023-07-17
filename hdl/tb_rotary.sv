`timescale 1ns / 1ps
module tb_rotary();
    bit clk,rst=1,a=1,b=1;
    logic [3:0]val;
    always #5ns clk<=!clk;
    
    initial begin
        #10ns
        rst<=0;
        #1us
        incr;
        #1us
        incr;
        #1us
        decr;
        #200ns
        $finish;
    end
    rotary dut(.*);
    
    task incr();
        a<=0;
        #200ns
        b<=0;
        #200ns
        a<=1;
        #200ns
        b<=1;
    endtask
    
    task decr();
        b<=0;
        #200ns
        a<=0;
        #200ns
        b<=1;
        #200ns
        a<=1;
    endtask

endmodule
