`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 09:41:07 PM
// Design Name: 
// Module Name: adder_4
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


module adder(
    input  logic a_i,
    input  logic b_i,
    input  logic carry_i,
    
    output logic sum_o,
    output logic carry_o,
    
    output logic G_o,
    output logic P_o
    );
    assign carry_o = (a_i & b_i) | (a_i & carry_i) | (b_i & carry_i);
    assign sum_o   = a_i ^ b_i ^ carry_i;
    assign G_o     = a_i & b_i;
    assign P_o     = a_i ^ b_i;
endmodule
