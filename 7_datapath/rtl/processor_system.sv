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
  input  logic        resetn_i,

  // Входы и выходы периферии
  input  logic [15:0] sw_i,       // Переключатели

  output logic [15:0] led_o,      // Светодиоды

  input  logic        kclk_i,     // Тактирующий сигнал клавиатуры
  input  logic        kdata_i,    // Сигнал данных клавиатуры

  output logic [ 6:0] hex_led_o,  // Вывод семисегментных индикаторов
  output logic [ 7:0] hex_sel_o,  // Селектор семисегментных индикаторов

  input  logic        rx_i,       // Линия приёма по UART
  output logic        tx_o,       // Линия передачи по UART

  output logic [3:0]  vga_r_o,    // Красный канал vga
  output logic [3:0]  vga_g_o,    // Зелёный канал vga
  output logic [3:0]  vga_b_o,    // Синий канал vga
  output logic        vga_hs_o,   // Линия горизонтальной синхронизации vga
  output logic        vga_vs_o    // Линия вертикальной синхронизации vga
);
  //Instruction Memory
  logic [31:0] instr;
  logic [31:0] instr_addr;
  
  //Stall/ready
  logic stall;
  logic ready;

  //Core
  logic [31: 0] core_rd;
  logic         core_req;
  logic         core_we;
  logic [ 2: 0] core_size;
  logic [31: 0] core_wd;
  logic [31: 0] core_addr;
  logic irq_req;
  logic irq_ret;

  //Data mem
  logic [31: 0] mem_rd;
  logic         mem_req;
  logic         mem_we;
  logic [ 3: 0] mem_be;
  logic [31: 0] mem_wd;
  logic [31: 0] mem_addr;

  instr_mem Instruction_Memory(
    .read_addr_i(instr_addr),
    .read_data_o(instr     )
  );

  processor_core core(
    .clk_i       (clk_i     ),
    .rst_i       (rst_i     ),

    .stall_i     (stall     ),
    .instr_i     (instr     ),
    .mem_rd_i    (core_rd   ),
    .irq_req_i   (irq_req   ),

    .instr_addr_o(instr_addr),
    .mem_addr_o  (core_addr ),
    .mem_size_o  (core_size ),
    .mem_req_o   (core_req  ),
    .mem_we_o    (core_we   ),
    .mem_wd_o    (core_wd   ),
    .irq_ret_o   (irq_ret   )
  );

  lsu LSU(
    .clk_i(clk_i),
    .rst_i(rst_i),

    // Интерфейс с ядром
    .core_req_i  (core_req ),
    .core_we_i   (core_we  ),
    .core_size_i (core_size),
    .core_addr_i (core_addr),
    .core_wd_i   (core_wd  ),
    .core_rd_o   (core_rd  ),   
    .core_stall_o(stall    ),

    // Интерфейс с памятью
    .mem_req_o  (mem_req ),
    .mem_we_o   (mem_we  ),
    .mem_be_o   (mem_be  ),
    .mem_addr_o (mem_addr),
    .mem_wd_o   (mem_wd  ),
    .mem_rd_i   (mem_rd  ),
    .mem_ready_i(ready   )
  );

  data_mem Data_Memory(
    .clk_i         (clk_i   ),
    .mem_req_i     (mem_req ),
    .write_enable_i(mem_we  ),
    .byte_enable_i (mem_be  ),
    .addr_i        (mem_addr),
    .write_data_i  (mem_wd  ),
    .read_data_o   (mem_rd  ),
    .ready_o       (ready   )
  );
endmodule