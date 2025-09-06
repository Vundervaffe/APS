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


module CLU#(
    parameter WIDTH = 16
)(
    input  logic [WIDTH -1:0] G_i,
    input  logic [WIDTH -1:0] P_i,
    input  logic              carry_i,
    output logic [WIDTH   :0] carry_o
    );
    assign carry_o[0] = carry_i;
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : carry_gen
            assign carry_o[i+1] = G_i[i] | (P_i[i] & carry_o[i]);
        end
    endgenerate 
endmodule
