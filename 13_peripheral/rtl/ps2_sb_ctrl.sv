`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 16:15:47
// Design Name: 
// Module Name: ps2_sb_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:  awd
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ps2_sb_ctrl(
/*
    Часть интерфейса модуля, отвечающая за подключение к системной шине
*/
  input  logic         clk_i,
  input  logic         rst_i,
  input  logic [31:0]  addr_i,
  input  logic         req_i,
  input  logic [31:0]  write_data_i,
  input  logic         write_enable_i,
  output logic [31:0]  read_data_o,

/*
    Часть интерфейса модуля, отвечающая за отправку запросов на прерывание
    процессорного ядра
*/
  output logic        interrupt_request_o,
  input  logic        interrupt_return_i,

/*
    Часть интерфейса модуля, отвечающая за подключение к модулю,
    осуществляющему приём данных с клавиатуры
*/
  input  logic kclk_i,
  input  logic kdata_i
);

  logic [7:0] scan_code;
  logic       scan_code_is_unread;
  logic [7:0] keycode;
  logic       valid;

  PS2Receiver PS2R(
    .clk_i          (clk_i  ), // Сигнал тактирования
    .rst_i          (rst_i  ), // Сигнал сброса
    .kclk_i         (kclk_i ), // Тактовый сигнал, приходящий с клавиатуры
    .kdata_i        (kdata_i), // Сигнал данных, приходящий с клавиатуры
    .keycode_o      (keycode), // Сигнал полученного с клавиатуры скан-кода клавиши
    .keycode_valid_o(valid  )  // Сигнал готовности данных на выходе keycodeout
  );

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      scan_code           <= 8'b0;
      scan_code_is_unread <= 1'b0;
    end else if (valid) begin
      scan_code           <= keycode;
      scan_code_is_unread <= 1'b1;
    end else if ((req_i & (addr_i[31:24] == 8'h00)) || interrupt_return_i) begin
      if (!valid) begin
        scan_code_is_unread <= 1'b0;
      end
    end else if (req_i & write_enable_i & (addr_i[31:24] == 8'h24)) begin
      scan_code           <= 8'b0;
      scan_code_is_unread <= 1'b0;
    end
  end

  always_comb begin 
    case (addr_i[7:0])
      8'h00: read_data_o = {0, scan_code};           
      8'h04: read_data_o = {0, scan_code_is_unread}; 
      8'h24: read_data_o = 32'b0;                        
    endcase
  end
  assign interrupt_request_o = scan_code_is_unread;

endmodule
