`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 09:20:02 PM
// Design Name: 
// Module Name: adder_32
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


module adder_32#(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    input  logic             carry_i,
    
    output logic [WIDTH-1:0] sum_o,
    output logic             carry_o 
    );
    
    logic [WIDTH/4-1:0] carries;
    
    adder_4 add[7:0](
        .a_i    (a_i    ),
        .b_i    (b_i    ),
        .carry_i({carries[WIDTH/4-1-1:0], carry_i}),
        .sum_o  (sum_o),
        .carry_o(carries)
    );
    assign carry_o = carries[WIDTH/4-1];
endmodule
