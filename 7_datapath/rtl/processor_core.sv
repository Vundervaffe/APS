`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 11:49:54
// Design Name: 
// Module Name: processor_core
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


module processor_core (
  input  logic        clk_i,
  input  logic        rst_i,

  input  logic        stall_i,
  input  logic [31:0] instr_i,
  input  logic [31:0] mem_rd_i,
  input  logic        irq_req_i,

  output logic [31:0] instr_addr_o,
  output logic [31:0] mem_addr_o,
  output logic [ 2:0] mem_size_o,
  output logic        mem_req_o,
  output logic        mem_we_o,
  output logic [31:0] mem_wd_o,
  output logic        irq_ret_o
);
  
  //PC
  logic [31:0] PC;

  // decoder 
  logic [1:0]   a_sel;
  logic [2:0]   b_sel;
  logic [4:0]   alu_op;
  logic [2:0]   csr_op;
  logic         csr_we;
  logic         mem_req;
  logic         mem_we;
  logic [2:0]   mem_size;
  logic         gpr_we;
  logic [1:0]   wb_sel;
  logic         illegal_instr;
  logic         branch;
  logic         jal;
  logic         jalr;
  logic         mret;

  // register
  logic        write_enable;
  logic [ 4:0] write_addr;
  logic [ 4:0] read_addr1;
  logic [ 4:0] read_addr2;
  logic [31:0] write_data;
  logic [31:0] read_data1;
  logic [31:0] read_data2;

  // alu
  logic [31:0]  a;
  logic [31:0]  b;
  logic         flag;
  logic [31:0]  result;

  //trap
  logic trap;
  assign trap = irq | illegal_instr;

  //irq
  logic [31:0] irq_cause;
  logic        irq;

  //csr
  logic [31:0] mcause;
  logic [31:0] mie;
  logic [31:0] csr_wd;
  logic [31:0] mepc;
  logic [31:0] mtvec;
  assign mcause = (illegal_instr) ? (32'h0000_0002) : irq_cause;

  // register assign
  assign write_enable = gpr_we & ~(stall_i | trap);
  assign read_addr1   = instr_i[19:15];
  assign read_addr2   = instr_i[24:20];
  assign write_addr   = instr_i[11: 7];
  always_comb begin 
    case (wb_sel)
      'd0: write_data = result;
      'd1: write_data = mem_rd_i;
      'd2: write_data = csr_wd;
    endcase
  end

  //PC Realisation
  logic [12:0] imm_b;
  assign imm_b = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
  logic [20:0] imm_j;
  assign imm_j = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      PC <= 0;
    end
    else if(!stall_i | trap) begin
      case(mret)
        0: begin
          case(trap)
            0: begin
              case(jalr)
                0: begin
                  case(jal | (flag & branch))
                    0: begin
                      PC <= PC + 4;
                    end
                    1: begin
                      PC <= PC + ((branch)? $signed(imm_b) : $signed(imm_j));
                    end
                  endcase
                end
                1: begin
                  PC <= read_data1 + $signed(instr_i[31:20]);
                end
              endcase
            end
            1: begin
              PC <= mtvec;
            end
          endcase
        end
        1: begin
          PC <= mepc;
        end
      endcase
    end
  end

  //alu assign
  always_comb begin
    case(a_sel)
      0: a = read_data1;
      1: a = PC;
      2: a = 0;
    endcase

    case(b_sel)
      0: b = read_data2;
      1: b = $signed(instr_i[31:20]);
      2: b = {instr_i[31:12], 12'h0000};
      3: b = $signed({instr_i[31:25], instr_i[11: 7]});
      4: b = 4;
    endcase
  end

  decoder Main_Decoder(
    .fetched_instr_i(instr_i      ),

    .a_sel_o        (a_sel        ),
    .b_sel_o        (b_sel        ),
    .alu_op_o       (alu_op       ),
    .csr_op_o       (csr_op       ),
    .csr_we_o       (csr_we       ),
    .mem_req_o      (mem_req      ),
    .mem_we_o       (mem_we       ),
    .mem_size_o     (mem_size     ),
    .gpr_we_o       (gpr_we       ),
    .wb_sel_o       (wb_sel       ),
    .illegal_instr_o(illegal_instr),
    .branch_o       (branch       ),
    .jal_o          (jal          ),
    .jalr_o         (jalr         ),
    .mret_o         (mret         )
  );
  
  register_file Register_File(
    .clk_i         (clk_i       ),
    .write_enable_i(write_enable),

    .write_addr_i  (write_addr  ),
    .read_addr1_i  (read_addr1  ),
    .read_addr2_i  (read_addr2  ),

    .write_data_i  (write_data  ),
    .read_data1_o  (read_data1  ),
    .read_data2_o  (read_data2  )
  );

  alu ALU(
    .a_i     (a     ),
    .b_i     (b     ),
    .alu_op_i(alu_op),
    .flag_o  (flag  ),
    .result_o(result)
  );
  
  interrupt_controller irq_controller(
    .clk_i      (clk_i        ),
    .rst_i      (rst_i        ),
    .exception_i(illegal_instr),
    .irq_req_i  (irq_req_i    ),
    .mie_i      (mie[16]      ),
    .mret_i     (mret         ),

    .irq_ret_o  (irq_ret_o),
    .irq_cause_o(irq_cause),
    .irq_o      (irq      )
  ); 
  logic [31:0] imm_Z;
  assign imm_Z = {27'b0, instr_i[19:15]};
  csr_controller csr(
    .clk_i (clk_i),
    .rst_i (rst_i),
    .trap_i(trap ),

    .opcode_i(csr_op),

    .addr_i        (instr_i[31:20]),
    .pc_i          (PC            ),
    .mcause_i      (mcause        ),
    .rs1_data_i    (read_data1    ),
    .imm_data_i    (imm_Z         ),
    .write_enable_i(csr_we        ),

    .read_data_o(csr_wd),
    .mie_o      (mie   ),
    .mepc_o     (mepc  ),
    .mtvec_o    (mtvec )
  );

  assign mem_size_o   = mem_size;
  assign mem_req_o    = mem_req & ~trap;
  assign mem_we_o     = mem_we & ~trap;
  assign mem_addr_o   = result;
  assign instr_addr_o = PC;
  assign mem_wd_o     = read_data2;
endmodule