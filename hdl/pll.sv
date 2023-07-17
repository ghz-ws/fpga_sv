module pll(
    input clk,
    output clk_out
    );
    logic locked;
    clk_wiz_0 mmcm(
        .clk_in1(clk),
        .clk_out1(clk_out),
        .locked(locked)
    );
endmodule