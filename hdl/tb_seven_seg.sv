`timescale 1ns / 1ps
module tb_seven_seg();
    bit clk,rst=1;
    bit [13:0]din=1234;
    logic [3:0]digit_sel;
    logic [6:0]seg_out;
    
    always #5ns clk<=!clk;
    
    initial begin
        #10ns
        rst<=0;
        #1us
        $finish;
    end
    
    logic [3:0]disp;
    always_comb begin
        case(seg_out)
            7'b0000001:disp=0;
            7'b1001111:disp=1;
            7'b0010010:disp=2;
            7'b0000110:disp=3;
            7'b1001100:disp=4;
            7'b0100100:disp=5;
            7'b0100000:disp=6;
            7'b0001111:disp=7;
            7'b0000000:disp=8;
            7'b0001100:disp=9;
            default:disp=0;
        endcase
    end
    seven_seg dut(.*);
endmodule