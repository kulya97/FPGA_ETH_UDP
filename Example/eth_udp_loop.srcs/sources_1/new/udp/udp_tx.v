module udp_tx (
    input        clk,      //ʱ���ź�
    input        rst_n,    //��λ�źţ��͵�ƽ��Ч
    input [47:0] des_mac,  //���͵�Ŀ��MAC��ַ
    input [31:0] des_ip,   //���͵�Ŀ��IP��ַ

    input             tx_start_en,  //��̫����ʼ�����ź�
    input      [ 7:0] tx_data,      //��̫������������
    input      [15:0] tx_byte_num,  //��̫�����͵���Ч�ֽ���
    output reg        tx_done,      //��̫����������ź�
    output reg        tx_req,       //�����������ź�

    input      [31:0] crc_data,  //CRCУ������
    input      [ 7:0] crc_next,  //CRC�´�У���������
    output reg        crc_en,    //CRC��ʼУ��ʹ��
    output reg        crc_clr,   //CRC���ݸ�λ�ź�

    output reg       gmii_tx_en,  //GMII���������Ч�ź�
    output reg [7:0] gmii_txd     //GMII�������
);

  //parameter define
  //������MAC��ַ
  parameter BOARD_MAC = 48'h00_11_22_33_44_55;
  //������IP��ַ
  parameter BOARD_IP = {8'd192, 8'd168, 8'd1, 8'd123};
  //Ŀ��MAC��ַ
  parameter DES_MAC = 48'hff_ff_ff_ff_ff_ff;
  //Ŀ��IP��ַ
  parameter DES_IP = {8'd192, 8'd168, 8'd1, 8'd102};
  //��̫��Э������ IPЭ��
  localparam ETH_TYPE = 16'h0800;

  //��̫��������С46���ֽڣ�IP�ײ�20���ֽ�+UDP�ײ�8���ֽ�
  //������������46-20-8=18���ֽ�
  localparam MIN_DATA_NUM = 16'd18;
  //reg define
  reg [6:0] cur_state;
  reg [6:0] next_state;
  localparam st_idle = 7'd0;  //��ʼ״̬���ȴ���ʼ�����ź�
  localparam st_init = 7'd1;  //��ʼ״̬���ȴ���ʼ�����ź�
  localparam st_check_sum = 7'd2;  //IP�ײ�У���
  localparam st_preamble = 7'd3;  //����ǰ����+֡��ʼ�綨��
  localparam st_eth_head = 7'd4;  //������̫��֡ͷ
  localparam st_ip_head = 7'd5;  //����IP�ײ�
  localparam st_udp_head = 7'd6;  //����UDP�ײ�
  localparam st_tx_data = 7'd7;  //��������
  localparam st_crc = 7'd8;  //����CRCУ��ֵ
  localparam st_done = 7'd9;
  /********************************************************/

  reg  [ 63:0] preamble_header;  //ǰ����
  reg  [111:0] eth_header;  //��̫������
  reg  [159:0] ip_header;  //ip����
  reg  [ 63:0] udp_header;  //udp����
  reg  [ 31:0] check_buffer;  //�ײ�У���


  reg  [ 15:0] tx_data_num;  //���͵���Ч�����ֽڸ���
  reg  [ 15:0] total_num;  //���ֽ���
  reg  [ 15:0] udp_num;  //UDP�ֽ���
  wire [ 15:0] real_tx_data_num;  //ʵ�ʷ��͵��ֽ���(��̫�������ֽ�Ҫ��)


  reg          start_en_d0;
  reg          start_en_d1;
  wire         pos_start_en;  //��ʼ��������������

  //*****************************************************
  //**                    main code
  //*****************************************************

  assign pos_start_en     = (~start_en_d1) & start_en_d0;
  assign real_tx_data_num = (tx_data_num >= MIN_DATA_NUM) ? tx_data_num : MIN_DATA_NUM;

  //��tx_start_en��������
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_en_d0 <= 1'b0;
      start_en_d1 <= 1'b0;
    end else begin
      start_en_d0 <= tx_start_en;
      start_en_d1 <= start_en_d0;
    end
  end

  //�Ĵ�������Ч�ֽ�
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_data_num <= 16'd0;
      total_num   <= 16'd0;
      udp_num     <= 16'd0;
    end else begin
      if (pos_start_en && cur_state == st_idle) begin
        //���ݳ���
        tx_data_num <= tx_byte_num;
        //IP���ȣ���Ч����+IP�ײ�����            
        total_num   <= tx_byte_num + 16'd28;
        //UDP���ȣ���Ч����+UDP�ײ�����            
        udp_num     <= tx_byte_num + 16'd8;
      end
    end
  end

  /*****************************************************************/
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

  always @(*) begin
    next_state = st_idle;
    case (cur_state)
      st_idle: begin  //�ȴ���������
        if (pos_start_en) next_state = st_init;
        else next_state = st_idle;
      end
      st_init: begin  //
        next_state = st_check_sum;
      end
      st_check_sum: begin  //IP�ײ�У��
        if (state_cnt == 12'd5 - 1) next_state = st_preamble;
        else next_state = st_check_sum;
      end
      st_preamble: begin  //����ǰ����+֡��ʼ�綨��
        if (state_cnt == 12'd8 - 1) next_state = st_eth_head;
        else next_state = st_preamble;
      end
      st_eth_head: begin  //������̫���ײ�
        if (state_cnt == 12'd14 - 1) next_state = st_ip_head;
        else next_state = st_eth_head;
      end
      st_ip_head: begin  //����IP�ײ�
        if (state_cnt == 12'd20 - 1) next_state = st_udp_head;
        else next_state = st_ip_head;
      end
      st_udp_head: begin  //UDP�ײ�
        if (state_cnt == 12'd8 - 1) next_state = st_tx_data;
        else next_state = st_udp_head;
      end
      st_tx_data: begin  //��������
        if (state_cnt == real_tx_data_num - 1) next_state = st_crc;
        else next_state = st_tx_data;
      end
      st_crc: begin  //����CRCУ��ֵ
        if (state_cnt == 12'd4 - 1) next_state = st_done;
        else next_state = st_crc;
      end
      st_done: begin
        next_state = st_idle;
      end
      default: next_state = st_idle;
    endcase
  end

  always @(posedge clk) begin
    if (cur_state == st_init) preamble_header[63:0] = {8'h55, 8'h55, 8'h55, 8'h55, 8'h55, 8'h55, 8'h55, 8'hd5};
    else if (cur_state == st_preamble) preamble_header[63:0] = {preamble_header[55:0], 8'h00};
    else preamble_header[63:0] <= preamble_header[63:0];
  end

  /**************************eth header***********************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) eth_header[111:0] = {DES_MAC[47:0], BOARD_MAC[47:0], ETH_TYPE[15:0]};
    else if (cur_state == st_init) eth_header[111:64] = des_mac[47:0];
    else if (cur_state == st_eth_head) eth_header[111:0] = {eth_header[103:0], 8'h00};
  end
  /**************************IP header***********************************/
  reg [4:0] cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      check_buffer     <= 32'd0;
      ip_header[159:0] <= 160'd0;
    end else if (cur_state == st_init) begin
      //�汾�ţ�4 �ײ����ȣ�5(��λ:32bit,20byte/4=5)
      ip_header[159:128] = {8'h45, 8'h00, total_num[15:0]};
      //16λ��ʶ��ÿ�η����ۼ�1     
      ip_header[127:112] = ip_header[127:112] + 1'b1;
      //bit[15:13]: 010��ʾ����Ƭ
      ip_header[111:96]  = 16'h4000;
      //Э�飺17(udp)                  
      ip_header[95:64]   = {8'h40, 8'h17, 8'h00, 8'h00};
      //ԴIP��ַ
      ip_header[63:32]   = BOARD_IP[31:0];
      //Ŀ��IP��ַ    
      if (des_ip != 32'd0) ip_header[31:0] <= des_ip[31:0];
      else ip_header[31:0] <= DES_IP[31:0];
    end else if (cur_state == st_check_sum) begin
      cnt <= cnt + 5'd1;
      if (cnt == 5'd0) begin
        check_buffer <= ip_header[159:144] + ip_header[143:128] + ip_header[127:112] + ip_header[111:96] + ip_header[95:80] + ip_header[79:64] + ip_header[63:48] + ip_header[47:32] + ip_header[31:16] + ip_header[15:0];
      end else if (cnt == 5'd1)  //���ܳ��ֽ�λ,�ۼ�һ��
        check_buffer <= check_buffer[31:16] + check_buffer[15:0];
      else if (cnt == 5'd2) begin  //�����ٴγ��ֽ�λ,�ۼ�һ��
        check_buffer <= check_buffer[31:16] + check_buffer[15:0];
      end else if (cnt == 5'd3) begin  //��λȡ��
        cnt              <= 5'd0;
        ip_header[79:64] <= ~check_buffer[15:0];
      end
    end else if (next_state == st_ip_head) ip_header[159:0] <= {ip_header[151:0], 8'h00};
  end
  /**************************udp header***********************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) udp_header[63:0] = 64'd0;
    else if (cur_state == st_init) begin
      //16λԴ�˿ںţ�1234
      udp_header[63:48] = {16'd1234};
      //16λĿ�Ķ˿ںţ�1234
      udp_header[47:32] = {16'd1234};
      //16λudp����
      udp_header[31:16] = udp_num[15:0];
      //16λudpУ���
      udp_header[15:0]  = 16'h0000;
    end else if (cur_state == st_udp_head) udp_header[63:0] = {udp_header[55:0], 8'h00};
  end
  /**************************gmii txd************************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) gmii_txd[7:0] <= 8'h00;
    else
      case (next_state)
        st_idle: begin  //�ȴ���������
          gmii_txd[7:0] <= 8'h00;
        end
        st_init: begin  //
          gmii_txd[7:0] <= 8'h00;
        end
        st_check_sum: begin  //IP�ײ�У��
          gmii_txd[7:0] <= 8'h00;
        end
        st_preamble: begin  //����ǰ����+֡��ʼ�綨��
          gmii_txd[7:0] <= preamble_header[63:56];
        end
        st_eth_head: begin  //������̫���ײ�
          gmii_txd[7:0] <= eth_header[111:104];
        end
        st_ip_head: begin  //����IP�ײ�
          gmii_txd[7:0] <= ip_header[159:152];
        end
        st_udp_head: begin  //UDP�ײ�
          gmii_txd[7:0] <= udp_header[63:56];
        end
        st_tx_data: begin  //��������
          gmii_txd[7:0] <= tx_data[7:0];
        end
        st_crc: begin  //����CRCУ��ֵ
          if (state_cnt == 3'd0) gmii_txd <= {~crc_next[0], ~crc_next[1], ~crc_next[2], ~crc_next[3], ~crc_next[4], ~crc_next[5], ~crc_next[6], ~crc_next[7]};
          else if (state_cnt == 3'd1) gmii_txd <= {~crc_data[16], ~crc_data[17], ~crc_data[18], ~crc_data[19], ~crc_data[20], ~crc_data[21], ~crc_data[22], ~crc_data[23]};
          else if (state_cnt == 3'd2) begin
            gmii_txd <= {~crc_data[8], ~crc_data[9], ~crc_data[10], ~crc_data[11], ~crc_data[12], ~crc_data[13], ~crc_data[14], ~crc_data[15]};
          end else if (state_cnt == 3'd3) begin
            gmii_txd <= {~crc_data[0], ~crc_data[1], ~crc_data[2], ~crc_data[3], ~crc_data[4], ~crc_data[5], ~crc_data[6], ~crc_data[7]};
          end
        end
        st_done: begin
          gmii_txd[7:0] <= 8'h00;
        end
        default: gmii_txd[7:0] <= 8'h00;
      endcase
  end

  always @(posedge clk) begin
    if (next_state == st_tx_data) tx_req <= 1'b1;
    else tx_req <= 1'b0;
  end

  always @(posedge clk) begin
    if (next_state == st_eth_head) crc_en <= 1'b1;
    else if (next_state == st_ip_head) crc_en <= 1'b1;
    else if (next_state == st_udp_head) crc_en <= 1'b1;
    else if (next_state == st_tx_data) crc_en <= 1'b1;
    else crc_en <= 1'b0;
  end


  always @(posedge clk) begin
    if (next_state == st_preamble) gmii_tx_en <= 1'b1;
    else if (next_state == st_eth_head) gmii_tx_en <= 1'b1;
    else if (next_state == st_ip_head) gmii_tx_en <= 1'b1;
    else if (next_state == st_udp_head) gmii_tx_en <= 1'b1;
    else if (next_state == st_tx_data) gmii_tx_en <= 1'b1;
    else if (next_state == st_crc) gmii_tx_en <= 1'b1;
    else gmii_tx_en <= 1'b0;
  end
  //��������źż�crcֵ��λ�ź�
  always @(posedge clk) begin
    if (next_state == st_done) begin
      tx_done <= 1'b1;
      crc_clr <= 1'b1;
    end
    begin
      tx_done <= 1'b0;
      crc_clr <= 1'b0;
    end
  end

endmodule

