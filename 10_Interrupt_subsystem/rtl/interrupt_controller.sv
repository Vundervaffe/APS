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
  input  logic [15:0] irq_req_i,
  input  logic [15:0] mie_i,
  input  logic        mret_i,

  output logic [15:0] irq_ret_o,
  output logic [31:0] irq_cause_o,
  output logic        irq_o
  );

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

  logic        irq_ret;
  logic        ready;
  logic [15:0] masked_irq;

  assign irq_ret    = ~(exception_i | exc_h) & mret_i;
  assign ready      = ~(irc_h | (exception_i | exc_h));
  assign masked_irq =  irq_req_i & mie_i;

  daisy_chain DC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    
    .masked_irq_i(masked_irq),
    .irq_ret_i   (irq_ret   ),
    .ready_i     (ready     ),
    
    .irq_ret_o  (irq_ret_o  ),
    .irq_cause_o(irq_cause_o),
    .irq_o      (irq_o      )
  );
endmodule
