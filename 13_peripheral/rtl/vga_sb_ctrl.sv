`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 12:39:40
// Design Name: 
// Module Name: vga_sb_ctrl
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


module vga_sb_ctrl (
  input  logic        clk_i,          // Системная тактовая (sysclk)
  input  logic        rst_i,
  input  logic        clk100m_i,      // Тактовая 100MHz для VGA
  input  logic        req_i,
  input  logic        write_enable_i,
  input  logic [3:0]  mem_be_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o,

  output logic [3:0]  vga_r_o,
  output logic [3:0]  vga_g_o,
  output logic [3:0]  vga_b_o,
  output logic        vga_hs_o,
  output logic        vga_vs_o
);

  logic        char_map_req_i;
  logic [ 9:0] char_map_addr_i;
  logic        char_map_we_i;
  logic [ 3:0] char_map_be_i;
  logic [31:0] char_map_wdata_i;
  logic [31:0] char_map_rdata_o;

  logic        col_map_req_i;
  logic [ 9:0] col_map_addr_i;
  logic        col_map_we_i;
  logic [ 3:0] col_map_be_i;
  logic [31:0] col_map_wdata_i;
  logic [31:0] col_map_rdata_o;

  logic        char_tiff_req_i;
  logic [ 9:0] char_tiff_addr_i;
  logic        char_tiff_we_i;
  logic [ 3:0] char_tiff_be_i;
  logic [31:0] char_tiff_wdata_i;
  logic [31:0] char_tiff_rdata_o;

  always_comb begin
    char_map_req_i = 1'b0;
    char_map_we_i = 1'b0;
    col_map_req_i = 1'b0;
    col_map_we_i = 1'b0;
    char_tiff_req_i = 1'b0;
    char_tiff_we_i = 1'b0;
    case (addr_i[7:0])
      2'b00: begin
        char_map_req_i = req_i;
        char_map_we_i = write_enable_i;
        read_data_o = char_map_rdata_o;
      end
      2'b01: begin
        col_map_req_i = req_i;
        col_map_we_i = write_enable_i;
        read_data_o = col_map_rdata_o;
      end
      2'b10: begin
        char_tiff_req_i = req_i;
        char_tiff_we_i = write_enable_i;
        read_data_o = char_tiff_rdata_o;
      end
    endcase
  end

  assign char_map_addr_i = addr_i[11:2];
  assign col_map_addr_i = addr_i[11:2];
  assign char_tiff_addr_i = addr_i[11:2];

  assign char_map_wdata_i = write_data_i;
  assign col_map_wdata_i = write_data_i;
  assign char_tiff_wdata_i = write_data_i;

  assign char_map_be_i = mem_be_i;
  assign col_map_be_i = mem_be_i;
  assign char_tiff_be_i = mem_be_i;

  vgachargen vga_core (
    .clk_i          (clk_i),           
    .clk100m_i      (clk100m_i),       
    .rst_i          (rst_i),

    .char_map_req_i (char_map_req_i),
    .char_map_addr_i(char_map_addr_i),
    .char_map_we_i  (char_map_we_i),
    .char_map_be_i  (char_map_be_i),
    .char_map_wdata_i(char_map_wdata_i),
    .char_map_rdata_o(char_map_rdata_o),

    .col_map_req_i  (col_map_req_i),
    .col_map_addr_i (col_map_addr_i),
    .col_map_we_i   (col_map_we_i),
    .col_map_be_i   (col_map_be_i),
    .col_map_wdata_i(col_map_wdata_i),
    .col_map_rdata_o(col_map_rdata_o),

    .char_tiff_req_i  (char_tiff_req_i),
    .char_tiff_addr_i (char_tiff_addr_i),
    .char_tiff_we_i   (char_tiff_we_i),
    .char_tiff_be_i   (char_tiff_be_i),
    .char_tiff_wdata_i(char_tiff_wdata_i),
    .char_tiff_rdata_o(char_tiff_rdata_o),

    .vga_r_o  (vga_r_o),
    .vga_g_o  (vga_g_o),
    .vga_b_o  (vga_b_o),
    .vga_hs_o (vga_hs_o),
    .vga_vs_o (vga_vs_o)
  );

endmodule