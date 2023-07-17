module div_unit(
    input clk,rst,
    input [11:0]Ain,
    input [3:0]Bin,
    output logic [11:0]Aout,
    output logic [3:0]Bout
    );
    logic [11:0]regA;
    logic [4:0]pr,sb;
    logic [3:0]mx;
    logic pq;
    always_comb begin   //divider 1 stage unit
        pr=regA[11:7];      //pr is 5 MSB of regA.
        sb=pr-{1'b0,Bout};   //sb=pr-B
        if(sb[4]==1)begin   //pr-B<0
            pq=0;
            mx=pr[3:0];     //mx=pr
        end else begin      //pr-B>=0
            pq=1;
            mx=sb[3:0];     //mx=pr-B
        end
        Aout={mx,regA[6:0],pq};
    end
    always_ff@(posedge clk)begin    //store register
        if(rst)begin
            regA<=0;
            Bout<=0;
        end else begin
            regA<=Ain;
            Bout<=Bin;
        end
    end
endmodule
