`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/02 14:50:53
// Design Name: 
// Module Name: tb_crc
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


module tb_crc;

  // udp_tx Parameters
  parameter PERIOD = 4;



  // udp_tx Inputs
  reg         clk = 1;
  reg         rst_n = 0;
  //wire define
  reg         crc_en = 0;  //CRC开始校验使能
  reg         crc_clr = 0;  //CRC数据复位信号 
  reg  [ 7:0] crc_d8;  //输入待校验8位数据

  wire [31:0] crc_data;  //CRC校验数据
  wire [31:0] crc_next;  //CRC下次校验完成数据



  always #(PERIOD / 2) clk = ~clk;

  initial begin
    #(PERIOD * 20) rst_n = 1;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'hd5;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h11;
    // crc_en = 1;
    // #(PERIOD * 1) crc_d8 = 8'h22;
    // #(PERIOD * 1) crc_d8 = 8'h33;
    // #(PERIOD * 1) crc_d8 = 8'h44;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h70;
    // #(PERIOD * 1) crc_d8 = 8'hb5;
    // #(PERIOD * 1) crc_d8 = 8'he8;
    // #(PERIOD * 1) crc_d8 = 8'h2b;
    // #(PERIOD * 1) crc_d8 = 8'ha6;
    // #(PERIOD * 1) crc_d8 = 8'h16;
    // #(PERIOD * 1) crc_d8 = 8'h08;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h45;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h30;
    // #(PERIOD * 1) crc_d8 = 8'hd5;
    // #(PERIOD * 1) crc_d8 = 8'hd1;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h80;
    // #(PERIOD * 1) crc_d8 = 8'h11;
    // #(PERIOD * 1) crc_d8 = 8'he3;
    // #(PERIOD * 1) crc_d8 = 8'h8e;
    // #(PERIOD * 1) crc_d8 = 8'hc0;
    // #(PERIOD * 1) crc_d8 = 8'ha8;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h02;
    // #(PERIOD * 1) crc_d8 = 8'hc0;
    // #(PERIOD * 1) crc_d8 = 8'ha8;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h0a;
    // #(PERIOD * 1) crc_d8 = 8'h04;
    // #(PERIOD * 1) crc_d8 = 8'hd2;
    // #(PERIOD * 1) crc_d8 = 8'h04;
    // #(PERIOD * 1) crc_d8 = 8'hd2;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h1c;
    // #(PERIOD * 1) crc_d8 = 8'hf2;
    // #(PERIOD * 1) crc_d8 = 8'h1c;  //udp header
    // #(PERIOD * 1) crc_d8 = 8'h01;
    // #(PERIOD * 1) crc_d8 = 8'h02;
    // #(PERIOD * 1) crc_d8 = 8'h03;
    // #(PERIOD * 1) crc_d8 = 8'h04;
    // #(PERIOD * 1) crc_d8 = 8'h05;
    // #(PERIOD * 1) crc_d8 = 8'h06;
    // #(PERIOD * 1) crc_d8 = 8'h07;
    // #(PERIOD * 1) crc_d8 = 8'h08;
    // #(PERIOD * 1) crc_d8 = 8'h09;
    // #(PERIOD * 1) crc_d8 = 8'h10;
    // #(PERIOD * 1) crc_d8 = 8'h11;
    // #(PERIOD * 1) crc_d8 = 8'h12;
    // #(PERIOD * 1) crc_d8 = 8'h13;
    // #(PERIOD * 1) crc_d8 = 8'h14;
    // #(PERIOD * 1) crc_d8 = 8'h15;
    // #(PERIOD * 1) crc_d8 = 8'h16;
    // #(PERIOD * 1) crc_d8 = 8'h17;
    // #(PERIOD * 1) crc_d8 = 8'h18;
    // #(PERIOD * 1) crc_d8 = 8'h19;
    // #(PERIOD * 1) crc_d8 = 8'h20;
    // #(PERIOD * 1) crc_d8 = 8'h77;
    // #(PERIOD * 1) crc_d8 = 8'hb5;
    // crc_en = 0;
    // #(PERIOD * 1) crc_d8 = 8'h27;
    // #(PERIOD * 1) crc_d8 = 8'hf6;  //64  
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'hd5;
    #(PERIOD * 1) crc_d8 = 8'h12;
    #(PERIOD * 1) crc_d8 = 8'h34;
    crc_en = 1;
    #(PERIOD * 1) crc_d8 = 8'h45;
    #(PERIOD * 1) crc_d8 = 8'h67;
    #(PERIOD * 1) crc_d8 = 8'h89;
    #(PERIOD * 1) crc_d8 = 8'hab;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h11;
    #(PERIOD * 1) crc_d8 = 8'h22;
    #(PERIOD * 1) crc_d8 = 8'h33;
    #(PERIOD * 1) crc_d8 = 8'h44;
    #(PERIOD * 1) crc_d8 = 8'h55;
    #(PERIOD * 1) crc_d8 = 8'h08;
    #(PERIOD * 1) crc_d8 = 8'h00;  //eth header
    #(PERIOD * 1) crc_d8 = 8'h45;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h30;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h40;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h40;
    #(PERIOD * 1) crc_d8 = 8'h17;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'hc0;
    #(PERIOD * 1) crc_d8 = 8'ha8;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h0a;
    #(PERIOD * 1) crc_d8 = 8'hc0;
    #(PERIOD * 1) crc_d8 = 8'ha8;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h02;
    #(PERIOD * 1) crc_d8 = 8'h04;
    #(PERIOD * 1) crc_d8 = 8'hd2;
    #(PERIOD * 1) crc_d8 = 8'h04;
    #(PERIOD * 1) crc_d8 = 8'hd2;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h1c;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h00;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h01;
    #(PERIOD * 1) crc_d8 = 8'h8b;
    #(PERIOD * 1) crc_d8 = 8'h6b;
    crc_en = 0;
    #(PERIOD * 1) crc_d8 = 8'hf5;
    #(PERIOD * 1) crc_d8 = 8'h13;

    //     #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'hd5;
    // #(PERIOD * 1) crc_d8 = 8'h70;
    // #(PERIOD * 1) crc_d8 = 8'hb5;
    // crc_en = 1;
    // #(PERIOD * 1) crc_d8 = 8'he8;
    // #(PERIOD * 1) crc_d8 = 8'h2b;
    // #(PERIOD * 1) crc_d8 = 8'ha6;
    // #(PERIOD * 1) crc_d8 = 8'h16;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h11;
    // #(PERIOD * 1) crc_d8 = 8'h22;
    // #(PERIOD * 1) crc_d8 = 8'h33;
    // #(PERIOD * 1) crc_d8 = 8'h44;
    // #(PERIOD * 1) crc_d8 = 8'h55;
    // #(PERIOD * 1) crc_d8 = 8'h08;
    // #(PERIOD * 1) crc_d8 = 8'h00;  //eth header
    // #(PERIOD * 1) crc_d8 = 8'h45;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h30;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h01;
    // #(PERIOD * 1) crc_d8 = 8'h40;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h40;
    // #(PERIOD * 1) crc_d8 = 8'h17;
    // #(PERIOD * 1) crc_d8 = 8'hb9;
    // #(PERIOD * 1) crc_d8 = 8'h59;
    // #(PERIOD * 1) crc_d8 = 8'hc0;
    // #(PERIOD * 1) crc_d8 = 8'ha8;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h0a;
    // #(PERIOD * 1) crc_d8 = 8'hc0;
    // #(PERIOD * 1) crc_d8 = 8'ha8;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h02;
    // #(PERIOD * 1) crc_d8 = 8'h04;
    // #(PERIOD * 1) crc_d8 = 8'hd2;
    // #(PERIOD * 1) crc_d8 = 8'h04;
    // #(PERIOD * 1) crc_d8 = 8'hd2;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h1c;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h00;
    // #(PERIOD * 1) crc_d8 = 8'h01;
    // #(PERIOD * 1) crc_d8 = 8'h02;
    // #(PERIOD * 1) crc_d8 = 8'h03;
    // #(PERIOD * 1) crc_d8 = 8'h04;
    // #(PERIOD * 1) crc_d8 = 8'h05;
    // #(PERIOD * 1) crc_d8 = 8'h06;
    // #(PERIOD * 1) crc_d8 = 8'h07;
    // #(PERIOD * 1) crc_d8 = 8'h08;
    // #(PERIOD * 1) crc_d8 = 8'h09;
    // #(PERIOD * 1) crc_d8 = 8'h10;
    // #(PERIOD * 1) crc_d8 = 8'h11;
    // #(PERIOD * 1) crc_d8 = 8'h12;
    // #(PERIOD * 1) crc_d8 = 8'h13;
    // #(PERIOD * 1) crc_d8 = 8'h14;
    // #(PERIOD * 1) crc_d8 = 8'h15;
    // #(PERIOD * 1) crc_d8 = 8'h16;
    // #(PERIOD * 1) crc_d8 = 8'h17;
    // #(PERIOD * 1) crc_d8 = 8'h18;
    // #(PERIOD * 1) crc_d8 = 8'h19;
    // #(PERIOD * 1) crc_d8 = 8'h20;
    // #(PERIOD * 1) crc_d8 = 8'h1f;
    // #(PERIOD * 1) crc_d8 = 8'ha3;
    // crc_en = 0;
    // #(PERIOD * 1) crc_d8 = 8'h72;
    // #(PERIOD * 1) crc_d8 = 8'hd2;
    #(PERIOD * 10) $finish;
  end

  wire [7:0] gmii_txd1;
  wire [7:0] gmii_txd2;
  wire [7:0] gmii_txd3;
  wire [7:0] gmii_txd4;
  wire [7:0] gmii_txd5;
  wire [7:0] gmii_txd6;
  wire [7:0] gmii_txd7;
  wire [7:0] gmii_txd8;
  assign gmii_txd1 = {~crc_data[24], ~crc_data[25], ~crc_data[26], ~crc_data[27], ~crc_data[28], ~crc_data[29], ~crc_data[30], ~crc_data[31]};
  assign gmii_txd2 = {~crc_data[16], ~crc_data[17], ~crc_data[18], ~crc_data[19], ~crc_data[20], ~crc_data[21], ~crc_data[22], ~crc_data[23]};
  assign gmii_txd3 = {~crc_data[8], ~crc_data[9], ~crc_data[10], ~crc_data[11], ~crc_data[12], ~crc_data[13], ~crc_data[14], ~crc_data[15]};
  assign gmii_txd4 = {~crc_data[0], ~crc_data[1], ~crc_data[2], ~crc_data[3], ~crc_data[4], ~crc_data[5], ~crc_data[6], ~crc_data[7]};

  assign gmii_txd5 = {~crc_next[24], ~crc_next[25], ~crc_next[26], ~crc_next[27], ~crc_next[28], ~crc_next[29], ~crc_next[30], ~crc_next[31]};
  assign gmii_txd6 = {~crc_next[16], ~crc_next[17], ~crc_next[18], ~crc_next[19], ~crc_next[20], ~crc_next[21], ~crc_next[22], ~crc_next[23]};
  assign gmii_txd7 = {~crc_next[8], ~crc_next[9], ~crc_next[10], ~crc_next[11], ~crc_next[12], ~crc_next[13], ~crc_next[14], ~crc_next[15]};
  assign gmii_txd8 = {~crc_next[0], ~crc_next[1], ~crc_next[2], ~crc_next[3], ~crc_next[4], ~crc_next[5], ~crc_next[6], ~crc_next[7]};

  //以太网发送CRC校验模块
  crc32_d8 u_crc32_d8 (
      .clk     (clk),
      .rst_n   (rst_n),
      .data    (crc_d8),
      .crc_en  (crc_en),
      .crc_clr (crc_clr),
      .crc_data(crc_data),
      .crc_next(crc_next)
  );
endmodule
