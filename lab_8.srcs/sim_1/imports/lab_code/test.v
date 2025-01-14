`timescale 1ps / 1ps

module test;

    // Inputs
    reg clk;
    reg enable;
    reg reset;
    reg start;
    reg read;
 //   reg rst_mem;
    reg[7:0]adress ;
    wire[6:0]light;
    reg btn_vld;
    reg hex2bcd;
    reg clkreset;
    wire [3:0]an;
    integer x;
    // Instantiate the Unit Under Test (UUT)
    cpu uut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .clkreset(clkreset),
        .start(start),
        .an(an),
        .read(read),
        .light(light),
        .btn(btn_vld),
        .hex2bcd(hex2bcd),
        //.rst_mem(rst_mem),
        .adress(adress)
    );
   always #1 clk = ~clk;

    initial begin
/***************************************************************start***************************************************************/
        x = 0;
        clk <= 0;
        clkreset <= 0;
        btn_vld <= 0;
        enable <= 0;
        start <= 0;
        read <= 0;
        reset <= 0;
        hex2bcd <= 0;
        adress <= 8'b0000_0000; 
        #100 reset <= 1;
             read <= 1;
        #100 read <= 0;
        #100 clkreset <= 1;
            reset <= 0;
        #100 clkreset <= 0;
             reset <= 1;
        #100 adress <= 8'b1111_1111;
        #100 enable <= 1;
        #10000 start <= 1;
       #100 adress <= 8'b0000_0000; 
        #10000 start <= 0;
        #10000 start <= 1;
        #100 start <= 0;
        #100 hex2bcd <= 1;
        #100 hex2bcd <= 0;
        
            
        
/*****************************************************************end***************************************************************/
        repeat (65)//输出网表
             begin
                $display("ADD:%h,CELL:%h",x,uut.d_mem.d_mem[x]);
                x=x+1;
                end
    end

endmodule

