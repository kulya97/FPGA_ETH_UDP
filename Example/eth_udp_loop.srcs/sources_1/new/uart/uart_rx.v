//*******************************************************************************/
module uart_rx
#(
	parameter CLK_FRE       =   50                  ,                                         //clock frequency(Mhz)
	parameter BAUD_RATE     =   115200              ,                                     //serial baud rate
    parameter IDLE_CYCLE    =    2                                          //��������
)
(
    input                        clk                ,                                       //ʱ��
    input                        rst_n              ,                                     //��λ
    output reg[7:0]              rx_data            ,                                   //����
    output reg                   rx_data_valid      ,                               //��Ч
    input                        rx_data_ready      ,                               //���
    output                       rx_frame_idle      ,                               //�����ж�
    output                       rx_interrupt       ,                               //�����ж�
    input                        rx_pin                                             //
);
/***********************************************************************/
localparam      CYCLE           = CLK_FRE * 1000000 / BAUD_RATE ;     //bit����
localparam      IDLE_TIME       = CYCLE * (IDLE_CYCLE+10)       ;        //�����ж�ʱ��
/***********************************************************************/
reg[2:0]                         state              ;
reg[2:0]                         next_state         ;
localparam                       S_IDLE      = 1    ;                           //����
localparam                       S_START     = 2    ;                           //start bit
localparam                       S_REC_BYTE  = 3    ;                           //data bits
localparam                       S_STOP      = 4    ;                           //stop bit
localparam                       S_DATA      = 5    ;
/***********************************************************************/
reg                              rx_d0              ;                                     //delay 1 clock for rx_pin
reg                              rx_d1              ;                                     //delay 1 clock for rx_d0
wire                             rx_negedge         ;                                //�����½��� 
reg[7:0]                         rx_bits            ;                                   //�������ݵ���ʱ�洢
reg[15:0]                        cycle_cnt          ;                                 //baud counter
reg[2:0]                         bit_cnt            ;                                    //bit counter
/***********************************************************************/
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
	begin
		rx_d0 <= 1'b0;
		rx_d1 <= 1'b0;	
	end
	else
	begin
		rx_d0 <= rx_pin;
		rx_d1 <= rx_d0;
	end
end

assign rx_negedge = rx_d1 && ~rx_d0;  //�½���
/***********************************************************************/
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		state <= S_IDLE;
	else
		state <= next_state;
end

always@(*)
begin
	case(state)
		S_IDLE:
			if(rx_negedge)
				next_state <= S_START;
			else
				next_state <= S_IDLE;
		S_START:
			if(cycle_cnt == CYCLE - 1)//һ�����������ת������״̬
				next_state <= S_REC_BYTE;
			else
				next_state <= S_START;
		S_REC_BYTE:
			if(cycle_cnt == CYCLE - 1  && bit_cnt == 3'd7)  //�������8bit��ת�Ƶ�ֹͣλ
				next_state <= S_STOP;
			else
				next_state <= S_REC_BYTE;
		S_STOP:
			if(cycle_cnt == CYCLE/2 - 1)//��λ���ڣ���������һ���ֽڽ�����
				next_state <= S_DATA;
			else
				next_state <= S_STOP;
		S_DATA:
			if(rx_data_ready)    //���ݽ������
				next_state <= S_IDLE;
			else
				next_state <= S_DATA;
		default:
			next_state <= S_IDLE;
	endcase
end
/***********************************************************************/
//bitʱ�Ӽ���
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		cycle_cnt <= 16'd0;
	else if((state == S_REC_BYTE && cycle_cnt == CYCLE - 1) || next_state != state)//״̬����ʱ��գ�����״̬ÿһ���ֽ����һ��
		cycle_cnt <= 16'd0;
	else
		cycle_cnt <= cycle_cnt + 16'd1;
end
/***********************************************************************/
//bit����
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		begin
			bit_cnt <= 3'd0;
		end
	else if(state == S_REC_BYTE)
		if(cycle_cnt == CYCLE - 1)//������״̬�����bit��+1
			bit_cnt <= bit_cnt + 3'd1;
		else
			bit_cnt <= bit_cnt;
	else
		bit_cnt <= 3'd0;
end
/***********************************************************************/
//����bit����
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		rx_bits <= 8'd0;
	else if(state == S_REC_BYTE && cycle_cnt == CYCLE/2 - 1)
		rx_bits[bit_cnt] <= rx_d1;
	else
		rx_bits <= rx_bits; 
end
/***********************************************************************/
//������յ���8bit����
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rx_data <= 8'd0;
	else if(state == S_STOP && next_state != state)
		rx_data <= rx_bits;//latch received data
end
/***********************************************************************/
//��������׼��״̬
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
		rx_data_valid <= 1'b0;
	else if(state == S_IDLE)//ֹͣλ�Ŀ�ʼ
	    rx_data_valid <= 1'b1;
	else
		rx_data_valid <= 1'b0;
end

/*
����Ϊ������ӵ�����
add��
    ���ڽ����ж�                    rx_bit_idle
    ���ڿ����ж�                    rx_frame_idle
    ���ڿ��н��յ�����λ��           rx_frame_bit_num
*/
/***********************************************************************/
//bit�ж�
assign rx_interrupt=((state==S_DATA) && (next_state != state));
/***********************************************************************/
//����ʱ�����
reg[31:0]   idle_cnt           ;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        idle_cnt<=1'd0;
    end
    else if(!rx_interrupt&&idle_cnt<IDLE_TIME)
        idle_cnt <= idle_cnt + 1'd1;
    else if(rx_interrupt)begin
        idle_cnt<=0;
    end
end
//֡���б�־
reg frame_idle_flag;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        frame_idle_flag<=1'd0;
    end
    else if(idle_cnt>=IDLE_TIME)begin
        frame_idle_flag<=1'b1;
    end
    else begin
        frame_idle_flag<=1'b0;
    end
end
//֡���б�־����
reg frame_idle_flag_n;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        frame_idle_flag_n<=1'b0;
    end
    else begin
        frame_idle_flag_n<=frame_idle_flag;
    end
end
assign rx_frame_idle=frame_idle_flag&&~frame_idle_flag_n;

endmodule