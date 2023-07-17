module sqrt_unit(
    input clk,rst,
    input [11:0]Ain,[5:0]Bin,
    output logic [11:0]Aout,[5:0]Bout
    );
    logic [11:0]regA;
    logic [5:0]regB;
    logic [5:0]pr,sb;
    always_comb begin   //sqrt 1 stage unit
        pr=regA[11:6];  //pr is 6 MSB of regA.
        sb=pr-regB;     //sb=pr-regB
        if(sb[5]==1)begin   //sb<0
            Aout={pr[3:0],regA[5:0],2'b0};
            Bout={regB[4:2],1'b0,2'b1};
        end else begin      //sb>=0
            Aout={sb[3:0],regA[5:0],2'b0};
            Bout={regB[4:2],1'b1,2'b1};
        end
    end
    
    always_ff@(posedge clk)begin
        if(rst)begin
            regA<=0;
            regB<=0;
        end else begin
            regA<=Ain;
            regB<=Bin;
        end
    end
endmodule
