module rx #(parameter div_ratio=868)(   //100M/115.2k=868
    input clk,rst,rx_line,
    output logic [7:0]rx_data,
    output logic busy,valid,err
    );
    // double latch to suppress glitch
    logic [1:0]rx_latch;
    always_ff@(posedge clk)begin
        if(rst)begin
            rx_latch<=2'b11;
        end else begin
            rx_latch<={rx_latch[0],rx_line};    
        end
    end
    //Gen. rx clk. 180 deg. phase delayed
    logic [$clog2(div_ratio+1):0]div;
    logic rx_clk;
    always_ff@(posedge clk) begin
        if(!busy)begin
            div<=0;
            rx_clk<=0;
        end else begin
            if(div==div_ratio/2)begin
                rx_clk<=1;
                div<=div+1;
            end else if(div==div_ratio-1)begin
                rx_clk<=0;
                div<=0;
            end else begin
                rx_clk<=0;
                div<=div+1;
            end       
        end
    end
    //data receive
    logic [2:0]bitcnt;
    logic [7:0]rx_buf;
    enum logic [1:0] {START, RECEIVE, STOP}state;
    always_ff@(posedge clk)begin
        if(rst)begin
            busy<=0;
            valid<=0;
            err<=0;
            rx_data<=0;
            state<=START;
        end else begin
            if(!busy&&rx_latch[1]==0)begin  //detect start bit
                busy<=1;
                valid<=0;
                err<=0;
            end else begin
                if(busy&&rx_clk)begin
                    case(state)
                        START:begin
                            bitcnt<=0;      //clear bit cnt
                            state<=RECEIVE;
                        end
                        RECEIVE:begin
                            rx_buf[bitcnt]<=rx_latch[1];   //data receive. LSB first
                            bitcnt<=bitcnt+1;
                            if(bitcnt==7)begin      //last bit
                                 state<=STOP;
                            end
                        end
                        STOP:begin
                            state<=START;
                            busy<=0;
                            if(rx_latch[1])begin
                                valid<=1;
                                err<=0;
                                rx_data<=rx_buf;
                            end else begin
                                err<=1;
                            end
                        end
                        default:begin
                            busy<=0;
                            state<=START;
                        end
                    endcase
               end
            end
        end
    end
endmodule
