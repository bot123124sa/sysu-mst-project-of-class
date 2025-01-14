                 module hex2bcd #(
    parameter   IN_DATA_W       =           16              ,//��������λ��
//    parameter   OUT_DATA_W      =           clogb2({{IN_DATA_W}{1'b1}})//�Զ�����������ݶ�Ӧ��ʮ����λ����
    parameter   OUT_DATA_W      =           8//�Զ�����������ݶ�Ӧ��ʮ����λ����
)(
    input                                   clk             ,//ϵͳʱ�ӣ�
    input                                   rst_n           ,//ϵͳ��λ���͵�ƽ��Ч��

    input       [IN_DATA_W-1:0]             din             ,//������������ݣ�
    input                                   din_vld         ,//����������Чָʾ�źţ��ߵ�ƽ��Ч��
    
    input                                   sign            ,//�������
    
    input                                   btn_vld         ,

    output reg  [4*OUT_DATA_W-1:0]          dout            ,//���8421BCD�룻
    output reg                              dout_vld         //���������Чָʾ�źţ��ߵ�ƽ��Ч��
    );

    localparam  CNT_W           =           clogb(IN_DATA_W-3);//�����������ݵ�λ���Զ�������Ҫ�ƶ���������
	//localparam  OUT_DATA_W      =           clogb2({{IN_DATA_W}{1'b1}});//�Զ�����������ݶ�Ӧ��ʮ����λ����

	reg         [IN_DATA_W-1:0]             din_ff0     ;
    reg                                     flag        ;
    reg         [CNT_W-1:0]                 cnt         ;
    reg         [IN_DATA_W+OUT_DATA_W*4-1:0]data_shift  ;
    reg                                     end_cnt_ff0 ;

    wire        [OUT_DATA_W*4-1:0]          data_compare;
    wire                                    add_cnt     ;
    wire                                    end_cnt     ;

	function integer clogb2(input integer depth);
        begin
            if(depth==0)
                clogb2 = 1;
            else if(depth!=0)
                for(clogb2=0;depth>0;clogb2=clogb2+1)
                    depth=depth/10;
        end
    endfunction

     //�Զ�����λ��
    function integer clogb(input integer depth);begin
        if(depth==0)
            clogb = 1;
        else if(depth!=0)
            for(clogb=0;depth>0;clogb=clogb+1)
                depth=depth>>1;
    end
    endfunction
    
    //������������Ч���Ҵ�ʱ��ģ�����ʱ�����������ݣ����򲻱����������ݣ��������Ա�֤����ת��������ȫ��ȷ��
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            din_ff0 <= 0;
        end
        else if(din_vld)begin
            din_ff0 <= din;
        end
    end

    //��־�ź�flag��������������Чʱ���ߣ����������������ʱ���㣻
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag <= 1'b0;
        end
        else if(din_vld)begin
            flag <= 1'b1;
        end
        else if(end_cnt)begin
            flag <= 1'b0;
        end
    end

    //��λ��������ÿ��ת����Ҫ�ƶ�IN_DATA_W-2�Σ���ʼֵΪ0����һ����flag�ź���Ч�����������Ǽ�����IN_DATA_W-2�Σ�
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt <= 0;
        end
        else if(add_cnt)begin
            if(end_cnt)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end

    assign add_cnt = flag;       
    assign end_cnt = add_cnt && cnt == IN_DATA_W-3;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            data_shift <= 0;
        end
        
        else if(add_cnt)begin
            if(cnt==0)begin//��ʼʱ����������������λ���棻
                data_shift <= {{{OUT_DATA_W-3}{1'b0}},din_ff0,3'b0};
            end
            else begin//��������һ������Чʱ������λ�Ĵ�����������һλ��
                data_shift <= {data_compare[OUT_DATA_W*4-2:0],data_shift[IN_DATA_W-1:0],1'b0};
            end
        end
    end

    //��λ����ڵ���5֮���3��
    generate
        genvar bit_num;
				for(bit_num = 0 ; bit_num < OUT_DATA_W ; bit_num = bit_num + 1)begin : DATA
                    assign data_compare[4*bit_num+3 : 4*bit_num] = data_shift[IN_DATA_W+4*bit_num+3 : IN_DATA_W+4*bit_num] + (data_shift[IN_DATA_W+4*bit_num+3 : IN_DATA_W+4*bit_num]>=5 ? 4'd3 : 4'd0);
        end
    endgenerate

    //���������ӳ�һ�ģ�������������źţ�
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            end_cnt_ff0 <= 1'b0;
        end
        else begin
            end_cnt_ff0 <= end_cnt;
        end
    end


    
    reg dout_switch_flag = 0;
    integer  i = 15;
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout <= 0;
            dout_switch_flag <=0;
        end
        else if(btn_vld && dout_switch_flag ==0)begin
            dout <={dout[15:0],dout[4*OUT_DATA_W-1:16]};
            dout_switch_flag <= 1;
        end
        else if(end_cnt_ff0 && btn_vld == 1'd0)begin
            dout <= data_shift[IN_DATA_W+OUT_DATA_W*4-1 : IN_DATA_W];
            dout_switch_flag <= 0; 
        end
        else if(din_vld== 1'd0)begin
            dout <= {16'd0,din[IN_DATA_W-1:0]};
        end
            
    end


    //ͨ�������������������������Чָʾ�źţ�
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_vld <= 1'b0;
        end
        else begin
            dout_vld <= end_cnt_ff0;
        end
    end

    endmodule