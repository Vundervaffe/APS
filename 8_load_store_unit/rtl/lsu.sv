`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2025 13:35:41
// Design Name: 
// Module Name: lsu
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


module lsu(
  input logic clk_i,
  input logic rst_i,

  // Интерфейс с ядром
  input  logic        core_req_i,
  input  logic        core_we_i,
  input  logic [ 2:0] core_size_i,
  input  logic [31:0] core_addr_i,
  input  logic [31:0] core_wd_i,
  output logic [31:0] core_rd_o,
  output logic        core_stall_o,

  // Интерфейс с памятью
  output logic        mem_req_o,
  output logic        mem_we_o,
  output logic [ 3:0] mem_be_o,
  output logic [31:0] mem_addr_o,
  output logic [31:0] mem_wd_o,
  input  logic [31:0] mem_rd_i,
  input  logic        mem_ready_i
);
  import decoder_pkg::*;

  logic stall;

  logic [1:0] byte_offset;
  logic       half_offset;

  assign byte_offset = core_addr_i[1:0];
  assign half_offset = core_addr_i[1];

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      stall <= '0;
    else
      stall <= core_stall_o;
  end
  assign core_stall_o = core_req_i & ~(mem_ready_i & stall);
  assign mem_req_o = core_req_i;
  assign mem_we_o = core_we_i;

  always_comb begin
    case (core_size_i)
      LDST_W: mem_be_o = 4'b1111;
      LDST_H: mem_be_o = (half_offset) ? 4'b1100 : 4'b0011;
      LDST_B: mem_be_o = (4'b0001) << (byte_offset);
    endcase
  end

  assign mem_addr_o = core_addr_i;

  always_comb begin
    case (core_size_i)
      LDST_W: core_rd_o = mem_rd_i;
      LDST_B: begin
        case(byte_offset)
          2'b00: core_rd_o = $signed(mem_rd_i[ 7: 0]);
          2'b01: core_rd_o = $signed(mem_rd_i[15: 8]);
          2'b10: core_rd_o = $signed(mem_rd_i[23:16]);
          2'b11: core_rd_o = $signed(mem_rd_i[31:24]);
        endcase
      end
      LDST_BU: begin
        case(byte_offset)
          2'b00: core_rd_o = mem_rd_i[ 7: 0];
          2'b01: core_rd_o = mem_rd_i[15: 8];
          2'b10: core_rd_o = mem_rd_i[23:16];
          2'b11: core_rd_o = mem_rd_i[31:24];
        endcase
      end
      LDST_H: begin
        case(half_offset)
          1'b0:  core_rd_o = $signed(mem_rd_i[15: 0]);
          1'b1:  core_rd_o = $signed(mem_rd_i[31:16]);
        endcase
      end
      LDST_HU: begin
        case(half_offset)
          1'b0:  core_rd_o = mem_rd_i[15: 0];
          1'b1:  core_rd_o = mem_rd_i[31:16];
        endcase
      end
    endcase
  end

  always_comb begin
    case(core_size_i)
      LDST_H: mem_wd_o = {{2{core_wd_i[15: 0]}}};
      LDST_W: mem_wd_o = core_wd_i;
      LDST_B: mem_wd_o = {{4{core_wd_i[ 7: 0]}}};
    endcase
  end
endmodule