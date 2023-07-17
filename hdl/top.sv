module top(
    input clk_in, ext_rst,rx,sw,
    output tx,led
    );
    logic clk,rst,locked;
    assign rst=(!locked)||ext_rst;
    echo echo(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx),
        .err()
        );
    clk_wiz_1 mmcm(
        .clk_out1(clk),
        .locked(locked),
        .clk_in1(clk_in)
        );
    sw_led #(.div_ratio(10000)) sw_led( //scan 10kHz
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .led(led)
        );
endmodule
