`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 10:29:33 PM
// Design Name: 
// Module Name: CYBERcobra
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


module CYBERcobra (
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic [15:0]  sw_i,
    
    output logic [31:0]  out_o
);
    logic [31:0] PC;
    logic [31:0] jmp;
    
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] res;
    logic        flag;
    logic        we;
    
    logic [31:0] wd;
    
    logic [31:0] instruction;
    

    
    always_comb begin
        case((flag & instruction[30]) | instruction[31])
            1'b0: jmp = 32'd4;
            1'b1: jmp = 32'({$signed(instruction[12:5]), 2'b00});
        endcase
    end
    
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            PC <= 32'b0;
        end
        else begin
            PC <= PC + jmp;
        end
    end
    
    
    instr_mem I_M(
        .read_addr_i(PC         ),
        .read_data_o(instruction)
    );
    
    always_comb begin
        case(instruction[29:28])
            2'b00: wd = 32'($signed(instruction[27:5]));
            2'b01: wd = res;
            2'b10: wd = 32'($signed(sw_i[15:0]));
            2'b11: wd = 32'b0;
        endcase
    end
    
    assign we = ~(instruction[30] & instruction[31]);
    
    register_file r_f(
        .clk_i         (clk_i             ),
        .write_enable_i(we                ),
        
        .write_addr_i  (instruction[ 4: 0]),
        .read_addr1_i  (instruction[22:18]),
        .read_addr2_i  (instruction[17:13]),
        
        .write_data_i  (wd                ),
        .read_data1_o  (a                 ),
        .read_data2_o  (b                 )
    );
    alu ALU(
        .a_i     (a                 ),
        .b_i     (b                 ),
        .alu_op_i(instruction[27:23]),
        .flag_o  (flag              ),
        .result_o(res               )
    );

    
    assign out_o = a;
    
endmodule
