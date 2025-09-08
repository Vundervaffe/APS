`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 01:28:02 PM
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


module adder_4(
    input  logic [3:0] a_i,
    input  logic [3:0] b_i,
    input  logic       carry_i,
    
    output logic [3:0] sum_o,
    output logic       carry_o
    );
    
    logic [3:0] G;
    logic [3:0] P;
    logic [3:0] carries;
    
    adder a_0(
        .a_i    (a_i[0]  ),
        .b_i    (b_i[0]  ),
        .carry_i(carry_i ),
        
        .sum_o  (sum_o[0]),
        .carry_o(        ),
        
        .G_o    (G[0]    ),
        .P_o    (P[0]    )
    );
    adder a_1(
        .a_i    (a_i[1]    ),
        .b_i    (b_i[1]    ),
        .carry_i(carries[0]),
        
        .sum_o  (sum_o[1]  ),
        .carry_o(          ),
        
        .G_o    (G[1]      ),
        .P_o    (P[1]      )
    );
    adder a_2(
        .a_i    (a_i[2]    ),
        .b_i    (b_i[2]    ),
        .carry_i(carries[1]),
        
        .sum_o  (sum_o[2]  ),
        .carry_o(          ),
        
        .G_o    (G[2]      ),
        .P_o    (P[2]      )
    );
    adder a_3(
        .a_i    (a_i[3]    ),
        .b_i    (b_i[3]    ),
        .carry_i(carries[2]),
        
        .sum_o  (sum_o[3]  ),
        .carry_o(          ),
        
        .G_o    (G[3]      ),
        .P_o    (P[3]      )
    );
    
    CLU clu(
        .G_i    (G      ),
        .P_i    (P      ),
        .carry_i(carry_i),
        .carry_o(carries)
    );
    assign carry_o = carries[3];
endmodule
