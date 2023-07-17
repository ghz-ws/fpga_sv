module pipe_div(
    input clk,rst,
    input [7:0]A,
    input [3:0]B,
    output [7:0]C    //C=A/B
    );
    logic [11:0]Aout1,Aout2,Aout3,Aout4,Aout5,Aout6,Aout7,Aout8;
    logic [3:0]Bout1,Bout2,Bout3,Bout4,Bout5,Bout6,Bout7;
    //pipeline stages. clk and rest is abbreviated by .*
    div_unit stage1(.*,.Ain({4'b0,A}),.Aout(Aout1),.Bin(B),.Bout(Bout1));
    div_unit stage2(.*,.Ain({Aout1}),.Aout(Aout2),.Bin(Bout1),.Bout(Bout2));
    div_unit stage3(.*,.Ain({Aout2}),.Aout(Aout3),.Bin(Bout2),.Bout(Bout3));
    div_unit stage4(.*,.Ain({Aout3}),.Aout(Aout4),.Bin(Bout3),.Bout(Bout4));
    div_unit stage5(.*,.Ain({Aout4}),.Aout(Aout5),.Bin(Bout4),.Bout(Bout5));
    div_unit stage6(.*,.Ain({Aout5}),.Aout(Aout6),.Bin(Bout5),.Bout(Bout6));
    div_unit stage7(.*,.Ain({Aout6}),.Aout(Aout7),.Bin(Bout6),.Bout(Bout7));
    div_unit stage8(.*,.Ain({Aout7}),.Aout(Aout8),.Bin(Bout7),.Bout());
    assign C=Aout8[7:0];
endmodule