`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/19 23:41:46
// Design Name: 
// Module Name: rth rx tb
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


module rth_rx_tb;

  // udp_rx Parameters
  parameter PERIOD = 10;
  //开发板MAC地址 00-11-22-33-44-55
  parameter BOARD_MAC = 48'h00_11_22_33_44_55;
  //开发板IP地址 192.168.1.10
  parameter BOARD_IP = {8'd192, 8'd168, 8'd0, 8'd10};
  //目的MAC地址 ff_ff_ff_ff_ff_ff
  parameter DES_MAC = 48'hff_ff_ff_ff_ff_ff;
  //目的IP地址 192.168.1.102     
  parameter DES_IP = {8'd192, 8'd168, 8'd0, 8'd2};

  // udp_rx Inputs
  reg         clk = 1;
  reg         rst_n = 0;
  reg         gmii_rx_dv = 0;
  reg  [ 7:0] gmii_rxd = 0;

  // udp_rx Outputs
  wire        rec_pkt_done;
  wire        rec_en;
  wire [31:0] rec_data;
  wire [15:0] rec_byte_num;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    #(PERIOD * 2) gmii_rx_dv = 0;
    #(PERIOD * 2) gmii_rxd = 8'h55;
    gmii_rx_dv = 1;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'hd5;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h11;
    #(PERIOD * 1) gmii_rxd = 8'h22;
    #(PERIOD * 1) gmii_rxd = 8'h33;
    #(PERIOD * 1) gmii_rxd = 8'h44;
    #(PERIOD * 1) gmii_rxd = 8'h55;
    #(PERIOD * 1) gmii_rxd = 8'h70;
    #(PERIOD * 1) gmii_rxd = 8'hb5;
    #(PERIOD * 1) gmii_rxd = 8'he8;
    #(PERIOD * 1) gmii_rxd = 8'h2b;
    #(PERIOD * 1) gmii_rxd = 8'ha6;
    #(PERIOD * 1) gmii_rxd = 8'h16;
    #(PERIOD * 1) gmii_rxd = 8'h08;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h45;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h28;
    #(PERIOD * 1) gmii_rxd = 8'h70;
    #(PERIOD * 1) gmii_rxd = 8'h12;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h80;
    #(PERIOD * 1) gmii_rxd = 8'h11;
    #(PERIOD * 1) gmii_rxd = 8'h49;
    #(PERIOD * 1) gmii_rxd = 8'h56;
    #(PERIOD * 1) gmii_rxd = 8'hc0;
    #(PERIOD * 1) gmii_rxd = 8'ha8;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h02;
    #(PERIOD * 1) gmii_rxd = 8'hc0;
    #(PERIOD * 1) gmii_rxd = 8'ha8;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h0a;
    #(PERIOD * 1) gmii_rxd = 8'h04;
    #(PERIOD * 1) gmii_rxd = 8'hd2;
    #(PERIOD * 1) gmii_rxd = 8'h04;
    #(PERIOD * 1) gmii_rxd = 8'hd2;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h14;
    #(PERIOD * 1) gmii_rxd = 8'h4a;
    #(PERIOD * 1) gmii_rxd = 8'h8f;
    #(PERIOD * 1) gmii_rxd = 8'h01;
    #(PERIOD * 1) gmii_rxd = 8'h02;
    #(PERIOD * 1) gmii_rxd = 8'h03;
    #(PERIOD * 1) gmii_rxd = 8'h04;
    #(PERIOD * 1) gmii_rxd = 8'h05;
    #(PERIOD * 1) gmii_rxd = 8'h06;
    #(PERIOD * 1) gmii_rxd = 8'h07;
    #(PERIOD * 1) gmii_rxd = 8'h08;
    #(PERIOD * 1) gmii_rxd = 8'h09;
    #(PERIOD * 1) gmii_rxd = 8'h10;
    #(PERIOD * 1) gmii_rxd = 8'h11;
    #(PERIOD * 1) gmii_rxd = 8'h12;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'h00;
    #(PERIOD * 1) gmii_rxd = 8'he8;
    #(PERIOD * 1) gmii_rxd = 8'h45;
    #(PERIOD * 1) gmii_rxd = 8'h16;
    #(PERIOD * 1) gmii_rxd = 8'h85;
    #(PERIOD * 1) gmii_rx_dv = 0;
  end

  udp_rx #(
      .BOARD_MAC(BOARD_MAC),
      .BOARD_IP (BOARD_IP)
  ) u_udp_rx (
      .clk       (clk),
      .rst_n     (rst_n),
      .gmii_rx_dv(gmii_rx_dv),
      .gmii_rxd  (gmii_rxd[7:0]),

      .rec_pkt_done(rec_pkt_done),
      .rec_en      (rec_en),
      .rec_data    (rec_data[31:0]),
      .rec_byte_num(rec_byte_num[15:0])
  );


endmodule
