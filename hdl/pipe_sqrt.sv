module pipe_sqrt(
    input clk,rst,
    input [7:0]A,
    output [3:0]B
    );
    logic [11:0]Aout1,Aout2,Aout3;
    logic [5:0]Bout1,Bout2,Bout3,Bout4;
    //pipeline stages. clk and rest is abbreviated by .*
    sqrt_unit stage1(.*,.Ain({4'b0,A}),.Aout(Aout1),.Bin({6'b1}),.Bout(Bout1));
    sqrt_unit stage2(.*,.Ain({Aout1}),.Aout(Aout2),.Bin(Bout1),.Bout(Bout2));
    sqrt_unit stage3(.*,.Ain({Aout2}),.Aout(Aout3),.Bin(Bout2),.Bout(Bout3));
    sqrt_unit stage4(.*,.Ain({Aout3}),.Aout(),.Bin(Bout3),.Bout(Bout4));
    assign B=Bout4[5:2];
endmodule
