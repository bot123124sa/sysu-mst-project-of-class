`timescale 1ns / 1ps
module D_mem(
 input wire wea,clk,
 input wire [7:0] addra,
 input wire [15:0] dina,
 input [7:0]addread,
 input reset,
 output reg[15:0] douta,
 output  wire [15:0]datareadout
);

reg [15:0] d_mem[255:0];

 assign  datareadout = d_mem[addread];
 // reset_mem
always @(posedge clk or negedge reset)
begin
 if(!reset)
  begin
  d_mem[0] <= 16'hfffd;
  d_mem[1] <= 16'h0004;
  d_mem[2] <= 16'h0005;
  d_mem[3] <= 16'hc369;
  d_mem[4] <= 16'h69c3;
  d_mem[5] <= 16'h0041;
  d_mem[6] <= 16'hffff;
  d_mem[7] <= 16'h0001;
  d_mem[8] <= 16'h0000;
  d_mem[9] <= 16'h0000;
  d_mem[10] <= 16'h0000;

end
 else begin
        if(wea == 1'b1)
             d_mem[addra] <= dina;
            else
            douta <= d_mem[addra];
end
end
//------------------------------------???¨¨??(?¡è????¨¨??always¨¨???????????????Imem???¨¦??????¡±?????---------------------------------------//
//initial begin
  //init_test
/*
  d_mem[0] <= 16'hfffd;
  d_mem[1] <= 16'h0004;
  d_mem[2] <= 16'h0005;
  d_mem[3] <= 16'hc369;
  d_mem[4] <= 16'h69c3;
  d_mem[5] <= 16'h0041;
  d_mem[6] <= 16'hffff;
  d_mem[7] <= 16'h0001;
  d_mem[8] <= 16'h0000;
  d_mem[9] <= 16'h0000;
  d_mem[10] <= 16'h0000;
*/
  //¹«±¶Êı
/*
  d_mem[0] <= 16'h0000;
  d_mem[1] <= 16'h0020;  //32
  d_mem[2] <= 16'h0018;   //24      8 96
*/
  //64badde
    /*
  d_mem[0] <= 16'hfffe;
  d_mem[1] <= 16'hfffe;
  d_mem[2] <= 16'hfffe;
  d_mem[3] <= 16'h0000;
  d_mem[4] <= 16'hffff;
  d_mem[5] <= 16'hffff;
  d_mem[6] <= 16'hffff;
  d_mem[7] <= 16'h0000;
 */
  //Ã°ÅİÅÅĞò
 /*
  d_mem[0] <= 16'h000a;
  d_mem[1] <= 16'h0004;
  d_mem[2] <= 16'h0005;
  d_mem[3] <= 16'h2369;
  d_mem[4] <= 16'h69c3;
  d_mem[5] <= 16'h0060;
  d_mem[6] <= 16'h0fff;
  d_mem[7] <= 16'h5555;
  d_mem[8] <= 16'h6152;
  d_mem[9] <= 16'h1057;
  d_mem[10] <= 16'h2895;
  d_mem[11] <= 16'h0000;
  */
    //ÅÅĞò
 /*
  d_mem[0] <= 16'h000a;
  d_mem[1] <= 16'h0009;
  d_mem[2] <= 16'h0006;
  d_mem[3] <= 16'h0005;
  d_mem[4] <= 16'h0001;
  d_mem[5] <= 16'h0004;
  d_mem[6] <= 16'h0003;
  d_mem[7] <= 16'h0011;
  d_mem[8] <= 16'h0000;
  d_mem[9] <= 16'h0000;

//
end*/
endmodule
