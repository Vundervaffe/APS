`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 02:54:56 PM
// Design Name: 
// Module Name: adder_32_testbench
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


module adder_32_testbench(
    
    );
    localparam WIDTH = 32;
    
    logic [WIDTH-1:0] a_i;
    logic [WIDTH-1:0] b_i;
    logic             carry_i;
    
    logic [WIDTH-1:0] sum_o;
    logic             carry_o;
    
    adder_32 #(
        .WIDTH(WIDTH)
    ) need(
        .a_i    (a_i    ),
        .b_i    (b_i    ),
        .carry_i(carry_i),
        
        .sum_o  (sum_o  ),
        .carry_o(carry_o)
    );
    initial begin
        repeat(100) begin
            a_i     = {$random()}%100;
            b_i     = {$random()}%100;
            carry_i = {$random()};
            #5ns;
            if ((a_i+b_i+carry_i) != ({carry_o, sum_o})) begin
                $error("sum is not correct. Module out: %d, correct is: %d", ({carry_o, sum_o}), (a_i+b_i+carry_i));
            end
            else begin
                $display("Module out: %d, reference is: %d", ({carry_o, sum_o}), (a_i+b_i+carry_i));
            end
            #5ns;
        end
    end
endmodule

