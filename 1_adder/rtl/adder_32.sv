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
    
    logic [WIDTH-1:0] G;
    logic [WIDTH-1:0] P;
    logic [WIDTH  :0] carries;
    
    generate
        for(genvar i = 0; i < WIDTH; i++) begin : adder_chain
            adder bit_adder(
                .a_i    (a_i[i]    ),
                .b_i    (b_i[i]    ),
                .carry_i(carries[i]),
                
                .sum_o  (sum_o[i]  ),
                .carry_o(          ),
                .G_o    (G[i]      ),
                .P_o    (P[i]      )
            );
        end 
    endgenerate
    
    CLU#(
        .WIDTH(WIDTH)
    ) clu(
        .G_i    (G      ),
        .P_i    (P      ),
        .carry_i(carry_i),
        .carry_o(carries)
    );
    assign carry_o = carries[WIDTH];
endmodule
