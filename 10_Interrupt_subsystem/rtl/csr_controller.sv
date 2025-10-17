`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2025 17:03:02
// Design Name: 
// Module Name: csr_controller
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


module csr_controller(
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic        trap_i,

  input  logic [ 2:0] opcode_i,

  input  logic [11:0] addr_i,
  input  logic [31:0] pc_i,
  input  logic [31:0] mcause_i,
  input  logic [31:0] rs1_data_i,
  input  logic [31:0] imm_data_i,
  input  logic        write_enable_i,

  output logic [31:0] read_data_o,
  output logic [31:0] mie_o,
  output logic [31:0] mepc_o,
  output logic [31:0] mtvec_o
);
  logic [31:0] data;
  import csr_pkg::*;
  always_comb begin
    case (opcode_i)
      CSR_RW:  data <=  rs1_data_i;
      CSR_RS:  data <=  rs1_data_i | read_data_o;
      CSR_RC:  data <= ~rs1_data_i & read_data_o;
      CSR_RWI: data <=  imm_data_i;
      CSR_RSI: data <=  imm_data_i | read_data_o;
      CSR_RCI: data <= ~imm_data_i & read_data_o;
    endcase
  end

  logic [31:0] data_ff [4:0];
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      data_ff <= {'0, '0, '0, '0, '0};
    else begin
      case (addr_i)
        MIE_ADDR: begin
          if(write_enable_i)
            data_ff[0] <= data;
        end
        MTVEC_ADDR: begin
          if(write_enable_i)
            data_ff[1] <= data;
        end
        MSCRATCH_ADDR: begin
          if(write_enable_i)
            data_ff[2] <= data;
        end
        MEPC_ADDR: begin
          if(write_enable_i)
            data_ff[3] <= (trap_i) ? pc_i : data;
        end
        MCAUSE_ADDR: begin
          if(write_enable_i)
            data_ff[4] <= (trap_i) ? mcause_i : data;
        end
      endcase
      if (trap_i) begin
        data_ff[3] <= (trap_i) ? pc_i : data;
        data_ff[4] <= (trap_i) ? mcause_i : data;
      end
    end
  end

  always_comb begin
    case(addr_i)
      MIE_ADDR:      read_data_o = data_ff[0];
      MTVEC_ADDR:    read_data_o = data_ff[1];
      MSCRATCH_ADDR: read_data_o = data_ff[2];
      MEPC_ADDR:     read_data_o = data_ff[3];
      MCAUSE_ADDR:   read_data_o = data_ff[4];
    endcase
  end

  assign mie_o   = data_ff[0];
  assign mtvec_o = data_ff[1];
  assign mepc_o  = data_ff[3];
endmodule
