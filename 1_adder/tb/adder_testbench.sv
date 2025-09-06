`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 10:37:26 PM
// Design Name: 
// Module Name: adder_4_testbench
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


module adder_testbench(

    );
    logic a_i;
    logic b_i;
    logic carry_i;
    
    logic sum_o;
    logic carry_o;
    
    logic G_o;
    logic P_o;
    adder need(
        .a_i    (a_i    ),
        .b_i    (b_i    ),
        .carry_i(carry_i),
        .sum_o  (sum_o  ),
        .carry_o(carry_o),
        .G_o    (G_o    ),
        .P_o    (P_o    )
    );
    initial begin
        repeat(100) begin
            a_i     = {$random()};
            b_i     = {$random()};
            carry_i = {$random()};
            #1ns;
            if ((a_i & b_i) | (a_i & carry_i) | (b_i & carry_i) != carry_o) begin
                $error("Carry is not correct. Module out: %b, correct is: %d", carry_o, (a_i & b_i) | (a_i & carry_i) | (b_i & carry_i));
                $stop;
            end
            if (a_i ^ b_i ^ carry_i != sum_o) begin
                $error("Sum is not correct. Module out: %b, correct is: %d", sum_o, a_i ^ b_i ^ carry_i);
                $stop;
            end
            if (a_i & b_i != G_o) begin
                $error("Generation signal is not correct. Module out: %b, correct is: %d", G_o, a_i & b_i);
                $stop;
            end
            if (a_i ^ b_i != P_o) begin
                $error("Propagate signal is not correct. Module out: %b, correct is: %d", P_o, a_i ^ b_i);
                $stop;
            end
            #9ns;
        end
    end
endmodule
