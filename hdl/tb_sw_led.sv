`timescale 1ns / 1ps
module tb_sw_led();
    bit clk,rst=1,sw;
    logic led;
    always #5ns clk<=!clk;
    
    initial begin
        #10ns
        rst<=0;
        #1us
        sw_push;
        #1us
        sw_push;
        #200ns
        $finish;
    end
    sw_led dut(.*);
    
    task sw_push();
        sw<=1;
        #500ns
        sw<=0;
    endtask
endmodule
