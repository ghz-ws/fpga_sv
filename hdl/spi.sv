module spi #(parameter div_ratio=100)(  //100M/1M=100
    input clk,rst,act,miso,mode,    //SPI mode
    input [31:0]tx_data,
    input [4:0]len,     //bit length
    output logic [31:0]rx_data,
    output logic busy,valid,mosi,sck,cs
    );
    //double latch to suppress glitch
    logic [1:0]miso_latch;
    always_ff@(posedge clk)begin
        if(rst)begin
            miso_latch<=0;
        end else begin
            miso_latch<={miso_latch[0],miso};    
        end
    end
    //Gen. tx clk
    logic [$clog2((div_ratio/2)+1):0]div;
    logic tx_clk;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            tx_clk<=0;
        end else begin
            if(div==(div_ratio/2)-1)begin
                tx_clk<=1;
                div<=0;
            end else begin
                tx_clk<=0;
                div<=div+1;
            end       
        end
    end
    //send and receive
    enum logic [1:0] {START,RECEIVE,SEND,FINISH}state;
    logic [31:0]tx_buf;
    logic [6:0]bitcnt;
    always_ff@(posedge clk)begin
        if(rst)begin
            state<=START;
            tx_buf<=0;
            rx_data<=0;
            cs<=1;
            bitcnt<=0;
            sck<=0;
            mosi<=0;
            busy<=0;
            valid<=0;
        end else begin
            if(act&&!busy)begin
                busy<=1;
                valid<=0;
                tx_buf<=tx_data;    //latch tx_data
            end else begin
                if(busy&&tx_clk)begin
                    case(state)
                        START:begin
                            state<=RECEIVE;
                            sck<=mode;
                            cs<=0;              //cs Lo
                            bitcnt<=1;          //clear and +1 bitcnt
                            mosi<=tx_buf[len-1];    //send fisrt bit. msb first
                        end
                        RECEIVE:begin
                            sck<=!sck;
                            rx_data[len-bitcnt]<=miso_latch[1];   //receive data. msb first
                            if(bitcnt==len)begin
                                state<=FINISH;
                            end else begin
                                state<=SEND;
                            end
                        end
                        SEND:begin
                            sck<=!sck;
                            mosi<=tx_buf[len-1-bitcnt];   //send data
                            state<=RECEIVE;
                            bitcnt<=bitcnt+1;
                        end
                        FINISH:begin
                            busy<=0;
                            sck<=0;
                            cs<=1;
                            state<=START;
                            valid<=1;
                        end
                        default:begin
                            state<=START;
                            sck<=0;
                        end
                    endcase
                end
            end
        end
    end
endmodule
