`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 07:56:16 PM
// Design Name: 
// Module Name: wrapper
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

localparam WIDTH = 32;
module wrapper(
    input  logic             clk_i,
    
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    input  logic             carry_i,
    
    output logic [WIDTH-1:0] sum_o,
    output logic             carry_o
    );
    
    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic             carry_input;
    logic [WIDTH-1:0] sum;
    logic             carry_out;
    
    always_ff @(posedge clk_i)begin
        a           <= a_i;
        b           <= b_i;
        carry_input <= carry_i;
    end
    
    adder_32#(
        .WIDTH(WIDTH)
    )need(
        .a_i    (a          ),
        .b_i    (b          ),
        .carry_i(carry_input),
        .sum_o  (sum        ),
        .carry_o(carry_out  )
    );
    
    always_ff @(posedge clk_i)begin
        sum_o   <= sum;
        carry_o <= carry_out;
    end
    
endmodule

