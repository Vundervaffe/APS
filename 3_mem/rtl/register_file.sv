`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 08:39:59 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
    input  logic        clk_i,
    input  logic        write_enable_i,

    input  logic [ 4:0] write_addr_i,
    input  logic [ 4:0] read_addr1_i,
    input  logic [ 4:0] read_addr2_i,

    input  logic [31:0] write_data_i,
    output logic [31:0] read_data1_o,
    output logic [31:0] read_data2_o
);
    logic [31:0] rf_mem [31:0];
    
    initial begin
        rf_mem[0] = 'b0;
    end
    
    always_comb begin
        read_data1_o = rf_mem[read_addr1_i];
        read_data2_o = rf_mem[read_addr2_i];
    end
    
    always_ff @(posedge clk_i) begin
        if (write_enable_i) begin
            if (write_addr_i != 0) begin
                rf_mem[write_addr_i] = write_data_i;
            end
        end 
    end
endmodule
