module seven_seg #(parameter div_ratio=100)(
    input clk,rst,
    input [13:0]din,
    output logic [3:0]digit_sel,  //digit selector
    output [6:0]seg_out     //7 seg
    );
    //Gen. refresh clk
    logic [$clog2(div_ratio+1):0]div;
    logic [1:0]digit;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            digit<=0;
        end else begin
            if(div==div_ratio-1)begin
                div<=0;
                if(digit==3)begin
                    digit<=0;
                end else begin
                    digit<=digit+1;
                end
            end else begin
                div<=div+1;
            end
        end
    end
    //digit sel.
    logic [3:0]seg0,seg1,seg2,seg3,seg_in;
    always_comb begin
        case(digit)
            0:begin
                seg_in=din%10;      //1
                digit_sel=4'b1110;
            end
            1:begin
                seg_in=(din/10)%10; //10
                digit_sel=4'b1101;
            end
            2:begin
                seg_in=(din/100)%10;    //100
                digit_sel=4'b1011;
            end
            3:begin
                seg_in=(din/1000)%10;   //1000
                digit_sel=4'b0111;
            end
            default:begin
                seg_in=0;
                digit_sel=4'b1111;
            end
        endcase
    end
    //decode
    assign seg_out=(seg_in==0)?7'b0000001:
                    (seg_in==1)?7'b1001111:
                    (seg_in==2)?7'b0010010:
                    (seg_in==3)?7'b0000110:
                    (seg_in==4)?7'b1001100:
                    (seg_in==5)?7'b0100100:
                    (seg_in==6)?7'b0100000:
                    (seg_in==7)?7'b0001111:
                    (seg_in==8)?7'b0000000:
                    (seg_in==9)?7'b0001100:
                    7'b1111111;
endmodule
