`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2025 16:38:55
// Design Name: 
// Module Name: interrupt_controller
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


module interrupt_controller(
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic        exception_i,
  input  logic        irq_req_i,
  input  logic        mie_i,
  input  logic        mret_i,

  output logic        irq_ret_o,
  output logic [31:0] irq_cause_o,
  output logic        irq_o
  );
  assign irq_cause_o = 32'h8000_0010;

  logic exc_h;
  logic irc_h;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      exc_h <= '0;
    else
      exc_h <= ~mret_i & (exception_i | exc_h);
  end

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      irc_h <= '0;
    else
      irc_h <= (irq_o | irc_h) & ~(~(exception_i | exc_h) & mret_i);
  end

  assign irq_o     = (irq_req_i & mie_i) & ~(irc_h | (exception_i | exc_h));
  assign irq_ret_o = ~(exception_i | exc_h) & mret_i;
endmodule
