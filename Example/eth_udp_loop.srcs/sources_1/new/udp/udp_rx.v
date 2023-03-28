//****************************************************************************************//

module udp_rx (
    input clk,   //ʱ���ź�
    input rst_n, //��λ�źţ��͵�ƽ��Ч

    input             gmii_rx_dv,    //GMII����������Ч�ź�
    input      [ 7:0] gmii_rxd,      //GMII��������
    output reg        rec_pkt_done,  //��̫���������ݽ�������ź�
    output reg        rec_en,        //��̫�����յ�����ʹ���ź�
    output reg [31:0] rec_data,      //��̫�����յ�����
    output reg [15:0] rec_byte_num   //��̫�����յ���Ч���� ��λ:byte     
);
  //parameter define
  //������MAC��ַ 00-11-22-33-44-55
  parameter BOARD_MAC = 48'h00_11_22_33_44_55;
  //������IP��ַ 192.168.1.10 
  parameter BOARD_IP = {8'd192, 8'd168, 8'd1, 8'd10};
  localparam ETH_TYPE = 16'h0800;  //��̫��Э������ IPЭ��

  reg  [ 63:0] preamble_header;  //ǰ����
  reg  [111:0] eth_header;  //��̫������
  reg  [159:0] ip_header;  //ip����
  reg  [ 63:0] udp_header;  //udp����
  //   reg [ 47:0] des_mac;  //Ŀ��MAC��ַ
  //   reg [ 15:0] eth_type;  //��̫������
  //   reg [ 31:0] des_ip;  //Ŀ��IP��ַ

  wire [ 47:0] des_mac;  //Ŀ��MAC��ַ
  wire [ 15:0] eth_type;  //��̫������
  wire [ 31:0] des_ip;  //Ŀ��IP��ַ
  wire [ 15:0] udp_byte_num;
  assign des_mac      = eth_header[111:64];
  assign eth_type     = eth_header[15:0];
  assign des_ip       = ip_header[31:0];
  assign udp_byte_num = udp_header[31:16];
  localparam st_idle = 7'd0;  //��ʼ״̬���ȴ�����ǰ����
  localparam st_preamble = 7'd1;  //����ǰ����״̬ 
  localparam st_eth_head = 7'd2;  //������̫��֡ͷ
  localparam st_ip_head = 7'd3;  //����IP�ײ�
  localparam st_udp_head = 7'd4;  //����UDP�ײ�
  localparam st_rx_data = 7'd5;  //������Ч����
  localparam st_rx_end = 7'd6;  //���ս���
  localparam st_rx_error = 7'd7;  //���ս���

  //reg define
  reg [6:0] cur_state;
  reg [6:0] next_state;
  /******************************************************/
  reg [7:0] rxd_data;  //��������
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rxd_data <= 8'd0;
    else rxd_data <= gmii_rxd;
  end
  //*****************************************************
  //**                    main code
  //*****************************************************

  //(����ʽ״̬��)ͬ��ʱ������״̬ת��
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cur_state <= st_idle;
    else cur_state <= next_state;
  end
  reg [11:0] state_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state_cnt <= 12'd0;
    else if (next_state != cur_state) state_cnt <= 12'd0;
    else state_cnt <= state_cnt + 1'd1;
  end

  //����߼��ж�״̬ת������
  always @(*) begin
    next_state = st_idle;
    case (cur_state)
      st_idle: begin  //�ȴ�
        if (gmii_rx_dv) next_state = st_preamble;
        else next_state = st_idle;
      end
      st_preamble: begin  //����ǰ����
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (state_cnt == 12'd8 - 1) next_state = st_eth_head;
        else next_state = st_preamble;
      end
      st_eth_head: begin  //������̫��֡ͷ
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (preamble_header[63:0] != 64'h5555_5555_5555_55d5) next_state = st_rx_error;  //ǰ�������
        else if (state_cnt == 12'd14 - 1) next_state = st_ip_head;
        else next_state = st_eth_head;
      end
      st_ip_head: begin  //����IP�ײ�
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (des_mac[47:0] != BOARD_MAC && (des_mac[47:0] != 48'hff_ff_ff_ff_ff_ff)) next_state = st_rx_error;  //����mac����
        else if (eth_header[15:0] != ETH_TYPE) next_state = st_rx_error;  //iptype����
        else if (state_cnt == 12'd20 - 1) next_state = st_udp_head;
        else next_state = st_ip_head;
      end
      st_udp_head: begin  //����UDP�ײ�
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (ip_header[31:0] != BOARD_IP) next_state = st_rx_error;  //����ip����
        else if ((state_cnt == 12'd8 - 1)) next_state = st_rx_data;
        else next_state = st_udp_head;
      end
      st_rx_data: begin  //������Ч����
        if (!gmii_rx_dv) next_state = st_rx_error;
        else if (state_cnt == udp_byte_num[15:0] - 16'd9) next_state = st_rx_end;
        else next_state = st_rx_data;
      end
      st_rx_end: begin  //���ս���
        if (!gmii_rx_dv) next_state = st_idle;
        else next_state = st_rx_end;
      end
      st_rx_error: begin  //�����쳣
        if (!gmii_rx_dv) next_state = st_idle;
        else next_state = st_rx_error;
      end
      default: next_state = st_idle;
    endcase
  end

  /****************����ǰ�����sfd*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) preamble_header <= 64'd0;
    else if (cur_state == st_idle) preamble_header <= 64'd0;
    else if (cur_state == st_preamble) preamble_header <= {preamble_header[55:0], rxd_data[7:0]};
    else preamble_header <= preamble_header;
  end
  /****************������̫��֡ͷ*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) eth_header <= 112'd0;
    else if (cur_state == st_idle) eth_header <= 112'd0;
    else if (cur_state == st_eth_head) eth_header <= {eth_header[103:0], rxd_data[7:0]};
    else eth_header <= eth_header;
  end

  /****************����ip����*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) ip_header <= 160'd0;
    else if (cur_state == st_idle) ip_header <= 160'd0;
    else if (cur_state == st_ip_head) ip_header <= {ip_header[151:0], rxd_data[7:0]};
    else ip_header <= ip_header;
  end
  /****************����udp����*************************/

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) udp_header <= 64'd0;
    else if (cur_state == st_idle) udp_header <= 64'd0;
    else if (cur_state == st_udp_head) udp_header <= {udp_header[55:0], rxd_data[7:0]};
    else udp_header <= udp_header;
  end
  /****************��������*************************/
  reg [3:0] rec_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_cnt <= 4'd0;
    else if (rec_cnt == 4'd3) rec_cnt <= 4'd0;
    else if (cur_state != next_state) rec_cnt <= 4'd0;  //������û��Ǹ�һ��
    else rec_cnt <= rec_cnt + 1'd1;
  end

  reg [7:0] rxd_data_d;  //��������
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rxd_data_d <= 8'd0;
    else rxd_data_d <= rxd_data;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_data <= 32'd0;
    else if (cur_state == st_idle) rec_data <= 32'd0;
    else if (cur_state != st_rx_data) rec_data <= 32'd0;
    else if (rec_cnt == 4'd0) rec_data[31:24] <= rxd_data[7:0];
    else if (rec_cnt == 4'd1) rec_data[23:16] <= rxd_data[7:0];
    else if (rec_cnt == 4'd2) rec_data[15:8] <= rxd_data[7:0];
    else if (rec_cnt == 4'd3) rec_data[7:0] <= rxd_data[7:0];
    else rec_data[7:0] <= rec_data[7:0];
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rec_en <= 1'd0;
    else if (cur_state == st_rx_data && rec_cnt == 4'd3 || (cur_state == st_rx_data && next_state == st_rx_end)) rec_en <= 1'b1;
    else rec_en <= 1'd0;
  end
  /***************************************************************/
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rec_pkt_done <= 1'd0;
      rec_byte_num <= 16'd0;
    end else if (cur_state == st_rx_data && next_state == st_rx_end) begin
      rec_pkt_done <= 1'b1;
      rec_byte_num <= udp_header[31:16] - 16'd8;
    end else begin
      rec_pkt_done <= 1'd0;
      rec_byte_num <= rec_byte_num;
    end
  end
endmodule
