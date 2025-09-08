`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 01:47:59 PM
// Design Name: 
// Module Name: CLA
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


module CLU(
    input  logic [3:0] G_i,
    input  logic [3:0] P_i,
    input  logic       carry_i,
    output logic [3:0] carry_o
    );
    assign carry_o[0] = G_i[0] | (P_i[0] & carry_i);
    assign carry_o[1] = G_i[1] | (G_i[0] & P_i[1] ) | (carry_i & P_i[0] & P_i[1]);
    assign carry_o[2] = G_i[2] | (G_i[1] & P_i[2] ) | (G_i[0]  & P_i[1] & P_i[2]) | (carry_i & P_i[0] & P_i[1] & P_i[2]);
    assign carry_o[3] = G_i[3] | (G_i[2] & P_i[3] ) | (G_i[1]  & P_i[2] & P_i[3]) | (G_i[0]  & P_i[1] & P_i[2] & P_i[3]) | (carry_i & P_i[0] & P_i[1] & P_i[2] & P_i[3]);
endmodule
