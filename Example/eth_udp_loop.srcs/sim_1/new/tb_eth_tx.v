`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/01 21:26:22
// Design Name: 
// Module Name: tb_eth_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_eth_tx;
  // udp_tx Parameters
  parameter PERIOD = 10;
  parameter BOARD_MAC = 48'h00_11_22_33_44_55;
  parameter BOARD_IP = {8'd192, 8'd168, 8'd0, 8'd10};
  parameter DES_MAC = 48'hff_ff_ff_ff_ff_ff;
  parameter DES_IP = {8'd192, 8'd168, 8'd0, 8'd2};


  // udp_tx Inputs
  reg         clk = 0;
  reg         rst_n = 0;
  reg  [47:0] des_mac = 48'h12_34_45_67_89_ab;
  reg  [31:0] des_ip = {8'd192, 8'd168, 8'd0, 8'd2};
  reg         tx_start_en = 0;
  reg  [ 7:0] tx_data = 0;
  reg  [15:0] tx_byte_num = 10;

  // udp_tx Outputs
  wire        tx_done;
  wire        tx_req;

  wire        gmii_tx_en;
  wire [ 7:0] gmii_txd;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    #(PERIOD * 10) tx_start_en = 1'b0;
    #(PERIOD * 1) tx_start_en = 1'b1;
    tx_data = 8'h0;
    wait (tx_req);
    #(PERIOD * 1) tx_data = 8'h1;
    #(PERIOD * 1) tx_data = 8'h2;
    #(PERIOD * 1) tx_data = 8'h3;
    #(PERIOD * 1) tx_data = 8'h4;
    #(PERIOD * 1) tx_data = 8'h5;
    #(PERIOD * 1) tx_data = 8'h6;
    #(PERIOD * 1) tx_data = 8'h7;
    #(PERIOD * 1) tx_data = 8'h8;
    #(PERIOD * 1) tx_data = 8'h9;
    #(PERIOD * 1) tx_data = 8'ha;
    #(PERIOD * 200);
    $finish;
  end



  //wire define
  wire        crc_en;  //CRC开始校验使能
  wire        crc_clr;  //CRC数据复位信号 
  wire [ 7:0] crc_d8;  //输入待校验8位数据

  wire [31:0] crc_data;  //CRC校验数据
  wire [31:0] crc_next;  //CRC下次校验完成数据

  //*****************************************************
  //**                    main code
  //*****************************************************

  assign crc_d8 = gmii_txd;

  udp_tx #(
      .BOARD_MAC(BOARD_MAC),
      .BOARD_IP (BOARD_IP),
      .DES_MAC  (DES_MAC),
      .DES_IP   (DES_IP)
  ) u_udp_tx (
      .clk        (clk),
      .rst_n      (rst_n),
      .des_mac    (des_mac[47:0]),
      .des_ip     (des_ip[31:0]),
      .tx_start_en(tx_start_en),
      .tx_data    (tx_data[7:0]),
      .tx_byte_num(tx_byte_num[15:0]),
      .crc_data   (crc_data[31:0]),
      .crc_next   (crc_next[7:0]),

      .tx_done   (tx_done),
      .tx_req    (tx_req),
      .crc_en    (crc_en),
      .crc_clr   (crc_clr),
      .gmii_tx_en(gmii_tx_en),
      .gmii_txd  (gmii_txd[7:0])
  );
  //以太网发送CRC校验模块
  crc32_d8 u_crc32_d8 (
      .clk     (gmii_tx_clk),
      .rst_n   (rst_n),
      .data    (crc_d8),
      .crc_en  (crc_en),
      .crc_clr (crc_clr),
      .crc_data(crc_data),
      .crc_next(crc_next)
  );
endmodule
