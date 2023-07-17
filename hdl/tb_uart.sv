`timescale 1ns / 1ps
module tb_uart();
    bit clk,rst=1;
    logic [7:0]tx_data=8'b10010110,rx_data;
    logic act,tx_line,busy_tx,busy_rx,rx_line,valid,err;
    
    assign rx_line=tx_line;
    always #5ns clk<=!clk;
    
    initial begin
        #20ns
        rst<=0;
        #20ns
        trig;
        @(posedge valid);
        #20ns
        assert(tx_data==rx_data)$display("PASS");else $display("FAIL");
        $finish;
    end
    
    tx tx(.*,.busy(busy_tx));
    rx rx(.*,.busy(busy_rx));
    
    task trig();
        act<=1;
        #20ns
        act<=0;
    endtask
endmodule