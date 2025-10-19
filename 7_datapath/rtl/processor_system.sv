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

  logic         req;
  //Instruction Memory
  logic [31:0] instr;
  logic [31:0] instr_addr;
  
  //Stall/ready
  logic stall;
  logic ready;

  //Data Keyboard
  logic [31:0] key_rd;
  logic        irq_request_from_ps2;
  logic        irq_return_to_ps2;

  //Core
  logic [31: 0] core_rd;
  logic         core_req;
  logic         core_we;
  logic [ 2: 0] core_size;
  logic [31: 0] core_wd;
  logic [31: 0] core_addr;
  logic [15: 0] irq_req;
  logic [15: 0] irq_ret;

  assign irq_req[0]        = irq_request_from_ps2;
  assign irq_return_to_ps2 = irq_ret[0];

  //LSU
  logic [31: 0] rd;

  //Data mem
  logic [31: 0] mem_rd;
  logic         mem_we;
  logic [ 3: 0] mem_be;
  logic [31: 0] mem_wd;
  logic [31: 0] mem_addr;

  //Data VGA
  logic [31:0] VGA_rd;

  logic sysclk, rst_i;
sys_clk_rst_gen divider(.ex_clk_i(clk_i),.ex_areset_n_i(resetn_i),.div_i(5),.sys_clk_o(sysclk), .sys_reset_o(rst_i));

  instr_mem Instruction_Memory(
    .read_addr_i(instr_addr),
    .read_data_o(instr     )
  );

  processor_core core(
    .clk_i       (sysclk),
    .rst_i       (rst_i),

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
    .clk_i(sysclk),
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
    .mem_req_o  (req     ),
    .mem_we_o   (mem_we  ),
    .mem_be_o   (mem_be  ),
    .mem_addr_o (mem_addr),
    .mem_wd_o   (mem_wd  ),
    .mem_rd_i   (rd      ),
    .mem_ready_i(ready   )
  );
  logic [255:0] OneHot_code;
  always_comb begin
    OneHot_code = 256'b1 << mem_addr[31:24];
  end
  data_mem Data_Memory(
    .clk_i         (sysclk                     ),
    .mem_req_i     (req & (OneHot_code[0] == 0)),
    .write_enable_i(mem_we                     ),
    .byte_enable_i (mem_be                     ),
    .addr_i        ({0, mem_addr[23:0]}        ),
    .write_data_i  (mem_wd                     ),
    .read_data_o   (mem_rd                     ),
    .ready_o       (ready                      )
  );

  ps2_sb_ctrl PS2_ctrl(
    .clk_i         (sysclk                     ),
    .rst_i         (rst_i                      ),
    .addr_i        ({0, mem_addr[23:0]}        ),
    .req_i         (req & (OneHot_code[0] == 3)),
    .write_data_i  (mem_wd                     ),
    .write_enable_i(mem_we                     ),
    .read_data_o   (key_rd                     ),

    .interrupt_request_o(irq_request_from_ps2),
    .interrupt_return_i (irq_return_to_ps2   ),

    .kclk_i (kclk_i ),
    .kdata_i(kdata_i)
  );
  assign led_o = key_rd;
  vga_sb_ctrl VGA_ctrl(
    .clk_i         (sysclk),
    .rst_i         (rst_i),
    .clk100m_i     (clk_i),
    .req_i         (req & (OneHot_code[0] == 7)),
    .write_enable_i(mem_we),
    .mem_be_i      (mem_be),
    .addr_i        ({0, mem_addr[23:0]}),
    .write_data_i  (key_rd),
    .read_data_o   (VGA_rd),

    .vga_r_o (vga_r_o ),
    .vga_g_o (vga_g_o ),
    .vga_b_o (vga_b_o ),
    .vga_hs_o(vga_hs_o),
    .vga_vs_o(vga_vs_o)
  );
  
  always_comb begin
    case (mem_addr[31:24])
      8'h00: rd = mem_rd;
      8'h03: rd = key_rd;
      8'h07: rd = VGA_rd;
    endcase
  end
endmodule