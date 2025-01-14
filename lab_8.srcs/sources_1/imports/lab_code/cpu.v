`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module cpu(
    input wire clk,
                enable,
                reset,
                read,
                clkreset,
                start,
                btn,
                hex2bcd,
                [7:0]adress ,
                
    output [6:0]light,
           [3:0]an,
    output [6:0]light2,
           [3:0]an2
);
//,rst_mem
wire [15:0] d_datain; //data from memory
wire [15:0] i_datain; //instruction
wire [7:0] d_addr;    //address for data memory
wire [15:0] d_dataout;//output data to data memory
wire d_we;            //write dm enable
wire [7:0] i_addr;    //pc
reg [15:0] d_data[255:0];
wire [15:0]datarst_memout;
wire [15:0]out;

wire [31:0]bcd_out;
reg   btn_vld     ;
wire  btn_out     ;
always@(posedge clk)
    begin
        btn_vld<=btn_out;
    end

hex2bcd #(
        .IN_DATA_W  ( 16    )//����16λ2�������ݣ�
        )
    u_hex2bcd (
        .clk        ( clk ),//ϵͳʱ���źţ�Ĭ��50MHz��
        .rst_n      ( reset       ),//ϵͳ��λ�źţ��͵�ƽ��Ч��
        .din        ( datarst_memout),//��Ҫ��ת���Ķ��������ݣ�
        .din_vld    ( hex2bcd      ),//��������һֱ��Ч��
        .dout       ( bcd_out   ),//ת����ɵ�BCD�����ݣ�
        .btn_vld    ( btn_vld   ),
        .dout_vld   (           )
    );
    
ego1_key #(
        .TCLK       ( 83      ),//ϵͳʱ��clk���ڣ���λns��
        .TIME_20MS  ( 20_000_000 ) //��������ʱ�䣬Ĭ��20ms����λns��
    )
    U_ego1_key(
        .clk(clk),
        .btn(btn),
        .btn_out(btn_out)
    );

PCPU pcpu(
    .clock(clk_out6_25MHh),
    .enable(enable),
    .reset(reset),
    .start(start),
    .d_datain(d_datain),
    .i_datain(i_datain),
    .d_addr(d_addr),
    .i_addr(i_addr),
    .d_dataout(d_dataout),
    .d_we(d_we),

    .y(out)
);

I_mem i_mem(
    .addr(i_addr),
    .clk(!clk_out6_25MHh),
    .douta(i_datain)
);

D_mem d_mem(
   .clk(clk),
   .reset(reset),
    .wea(d_we),
    .addra(d_addr),
    .dina(d_dataout),
    .douta(d_datain),
     .addread(adress),
    .datareadout(datarst_memout)
);

decoder t1(
    .clock(clk),
    .y(bcd_out[15:0]),
    .reset(read),
    .select_segment(light),
    .select_bit(an));

decoder t54(
    .clock(clk),
    .y(out),
    .reset(read),
    .select_segment(light2),
    .select_bit(an2));


clkd16 v1
(  .clk_out(clk_out6_25MHh),
    .rst(clkreset),
    .clk(clk) );

endmodule
