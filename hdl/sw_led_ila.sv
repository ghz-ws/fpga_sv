module sw_led_ila #(parameter div_ratio=10)(
    input clk,rst,sw,
    output logic led
    );
    //double latch to suppress glitch
    logic [1:0]sw_latch;
    always_ff@(posedge clk)begin
        if(rst)begin
            sw_latch<=0;
        end else begin
            sw_latch<={sw_latch[0],sw};
        end
    end
    //Gen. scan clk
    logic [$clog2(div_ratio+1):0]div;
    logic scanclk;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            scanclk<=0;
        end else begin
            if(div==div_ratio-1)begin
                div<=0;
			    scanclk<=1;
		    end else begin
			    div<=div+1;
			    scanclk<=0;
		    end
        end       
	end
    //led flip-flop
    logic [1:0]sw_edge;
    always_ff@(posedge clk)begin
        if(rst)begin
            sw_edge<=0;
            led<=0;
        end else begin
            if(scanclk)begin
                sw_edge<={sw_edge[0],sw_latch[1]};
                if(sw_edge==1)begin
                    led<=!led;
                end
            end
        end
    end
    ila_0 ila(
        .clk(clk),
        .probe0(sw_latch[1]),
        .probe1(scanclk),
        .probe2(sw_edge[1])
        );
endmodule
