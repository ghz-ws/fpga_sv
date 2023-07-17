`timescale 1ns / 1ps
module tb_spi();
    bit clk,rst=1,act,mode=1;
    bit [4:0]len=16;
    logic [31:0]tx_data='h81,rx_data;
    logic busy,miso,mosi,sck,valid,cs;
    
    assign miso=mosi;
    always #5ns clk<=!clk;
    
    initial begin
        #20ns
        rst<=0;
        #1us
        trig;
        @(posedge valid);
        #1us
        assert(tx_data==rx_data)$display("PASS");else $display("FAIL");
        $finish;
    end
    
    spi dut(.*);
    
    task trig();
        act<=1;
        #20ns
        act<=0;
    endtask
    
endmodule
