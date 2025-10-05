`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 13:38:30
// Design Name: 
// Module Name: processor_system
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


module processor_system(
  input  logic        clk_i,
  input  logic        rst_i
);
  //Instruction Memory
  logic [31:0] instr;
  logic [31:0] instr_addr;
  
  //Core
  logic [31: 0]mem_rd;
  logic         mem_req;
  logic         mem_we;
  logic [ 2: 0] mem_size;
  logic [31: 0] mem_wd;
  logic [31: 0] mem_addr;
  
  //stall
  logic stall;
  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      stall <= 0;
    end
    else begin
      stall <= (!stall & mem_req);
    end
  end 

  //walid data
  logic [3:0] bytes;
  always_comb begin
    case(mem_size)
      2: bytes = 4'b1111;
      1: bytes = 4'b0011;
      0: bytes = 4'b0001;
    endcase
  end

  instr_mem Instruction_Memory(
    .read_addr_i(instr_addr),
    .read_data_o(instr     )
  );

  processor_core core(
    .clk_i       (clk_i     ),
    .rst_i       (rst_i     ),

    .stall_i     (stall     ),
    .instr_i     (instr     ),
    .mem_rd_i    (mem_rd    ),

    .instr_addr_o(instr_addr),
    .mem_addr_o  (mem_addr  ),
    .mem_size_o  (mem_size  ),
    .mem_req_o   (mem_req   ),
    .mem_we_o    (mem_we    ),
    .mem_wd_o    (mem_wd    )
  );

  data_mem Data_Memory(
    .clk_i         (clk_i   ),
    .mem_req_i     (mem_req ),
    .write_enable_i(mem_we  ),
    .byte_enable_i (bytes   ),
    .addr_i        (mem_addr),
    .write_data_i  (mem_wd  ),
    .read_data_o   (mem_rd  ),
    .ready_o       (        )
  );
endmodule