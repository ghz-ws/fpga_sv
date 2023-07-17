module rotary #(parameter div_ratio=100)(
    input clk,rst,a,b,
    output logic [3:0]val
    );
    //double latch to suppress glitch
    logic [3:0]sw_latch;
    always_ff@(posedge clk)begin
        if(rst)begin
            sw_latch<=0;
        end else begin
            sw_latch<={sw_latch[2],b,sw_latch[0],a};
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
    //pulse detect
    logic [2:0]sw_edge;
    always_ff@(posedge clk)begin
        if(rst)begin
            sw_edge<=2'b11;
            val<=0;
        end else begin
            if(scanclk)begin
                sw_edge<={sw_latch[3],sw_edge[0],sw_latch[1]};
                if(sw_edge[1:0]==2'b10)begin
                    if(sw_edge[2]==0) val<=val-1;
                    else val<=val+1;
                end
            end
        end
    end
endmodule
