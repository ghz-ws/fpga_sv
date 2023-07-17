`timescale 1ns / 1ps
module tb_echo();
    bit clk,rst=1;
    logic [7:0]tx_data=8'b10010110;
    logic act,busy,tx,tx_line,rx,err;
    
    assign rx=tx_line;
    always #5ns clk<=!clk;
    
    initial begin
        #20ns
        rst<=0;
        #20ns
        trig;
        #30us
        $finish;
    end
    
    tx tx_unit(.*);
    echo dut(.*);
    
    task trig();
        act<=1;
        #20ns
        act<=0;
    endtask
endmodule