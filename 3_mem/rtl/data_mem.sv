`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 14:53:25
// Design Name: 
// Module Name: data_mem
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


module data_mem
import memory_pkg::DATA_MEM_SIZE_BYTES;
import memory_pkg::DATA_MEM_SIZE_WORDS;
(
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [ 3:0] byte_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o,
  output logic        ready_o
);
  logic [31:0] data [DATA_MEM_SIZE_WORDS];
  logic [31:0] write_data;
  always_comb begin
    if (byte_enable_i[0])
      write_data[ 7: 0] = write_data_i[ 7: 0];
    if (byte_enable_i[1])
      write_data[15: 8] = write_data_i[15: 8];
    if (byte_enable_i[2])
      write_data[23:16] = write_data_i[23:16];
    if (byte_enable_i[3])
      write_data[31:24] = write_data_i[31:24];
  end
  always_ff @(posedge clk_i) begin
    if (mem_req_i) begin
      if (write_enable_i) begin
        data[addr_i] <= write_data;
      end
      else begin
        read_data_o <= data[addr_i];
      end
    end
  end
  assign ready_o = 1;
endmodule