`timescale 1ns / 1ps

//��������ģ��
module ego1_key#(
    parameter       TCLK            =   100                      ,//ϵͳʱ�����ڣ���λns��
    parameter       TIME_20MS       =   1_00_00              //��������ʱ�䣬��λΪns��
)(
    input clk,
    input btn,//5������
    output btn_out
    );

    reg btn0=0;
    reg btn1=0;
    reg btn2=0;
    reg ledtest1;
    reg ledtest2;
    reg ledtest3=1'b1;
    reg[31:0] cnt1 = 0;
    reg[31:0] btnclk_cnt = 0;
    reg clk_ms = 0;
    reg btnclk = 0;
    
    always@ (posedge clk)//10MS����   100M/100 = 1000 000    100HZ
    begin
        if(btnclk_cnt==100)begin
        btnclk=~btnclk;
        btnclk_cnt=0;
        end
        else btnclk_cnt=btnclk_cnt+1'b1;
    end
    
    assign btn_out=(btn2&btn1&~btn0)|(btn2&btn1&btn0)|(~btn2&btn1&btn0);
    always@(posedge btnclk)
    begin
        btn0<=btn;
        btn1<=btn0;
        btn2<=btn1;
    end
endmodule


