`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 12:56:31
// Design Name: 
// Module Name: daisy_chain
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


module daisy_chain (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [15:0] masked_irq_i,
    input  logic        irq_ret_i,
    input  logic        ready_i,
    output logic [15:0] irq_ret_o,
    output logic [31:0] irq_cause_o,
    output logic        irq_o
);

  // Внутренние сигналы
  logic [15:0] ready;
  logic [15:0] cause;
  
  generate
    for (genvar i = 0; i < 16; i = i + 1) begin
      if (i == 0) begin
        assign ready[i] = ready_i;
      end
      else begin
        assign ready[i] = cause[0] & ready[i-1];
      end
    end
  endgenerate

  assign cause = masked_irq_i & ready;

  assign irq_cause_o = {12'h800, cause, 4'h0};

  logic [15:0] cause_ff;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i)
      cause_ff <= '0;
    else if(irq_o)
      cause_ff <= cause;
  end

  assign irq_o = |cause;
  assign irq_ret_o = (irq_ret_i) ? cause_ff : 16'b0;
endmodule