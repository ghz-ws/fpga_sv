module tx #(parameter div_ratio=868)(   //100M/115.2k=868
    input clk,rst,act,
    input [7:0]tx_data,
    output logic tx_line,
    output logic busy
    ); 
    //Gen. tx clk
    logic [$clog2(div_ratio+1):0]div;
    logic tx_clk;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            tx_clk<=0;
        end else begin
            if(div==div_ratio-1)begin
                tx_clk<=1;
                div<=0;
            end else begin
                tx_clk<=0;
                div<=div+1;
            end       
        end
    end
    //data send
    logic [2:0]bitcnt;
    logic [7:0]tx_buf;
    enum logic [1:0] {START, SEND, STOP, FINISH}state;
    always_ff@(posedge clk)begin
        if(rst)begin
            tx_line<=1;
            busy<=0;
            bitcnt<=0;
            state<=START;
        end else begin
            if(act&&!busy)begin //detect act pulse
                busy<=1;
                tx_buf<=tx_data;    //latch tx_data
            end else begin
                if(busy&&tx_clk)begin
                    case(state)
                        START:begin
                            tx_line<=0;      //send start bit 0
                            bitcnt<=0;      //clear bit cnt
                            state<=SEND;
                        end
                        SEND:begin
                            tx_line<=tx_buf[bitcnt];   //data send. LSB first
                            bitcnt<=bitcnt+1;
                            if(bitcnt==7)begin      //last bit
                                 state<=STOP;
                            end
                        end
                        STOP:begin
                            tx_line<=1;
                            state<=FINISH;
                        end
                        FINISH:begin
                            busy<=0;
                            state<=START;
                        end
                        default:begin
                            busy<=0;
                            tx_line<=1;
                            state<=START;
                        end
                    endcase
                end
            end
        end
    end
endmodule
