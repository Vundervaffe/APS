`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2025 05:10:40 PM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input  logic [31:0]  fetched_instr_i,
    output logic [1:0]   a_sel_o,
    output logic [2:0]   b_sel_o,
    output logic [4:0]   alu_op_o,
    output logic [2:0]   csr_op_o,
    output logic         csr_we_o,
    output logic         mem_req_o,
    output logic         mem_we_o,
    output logic [2:0]   mem_size_o,
    output logic         gpr_we_o,
    output logic [1:0]   wb_sel_o,
    output logic         illegal_instr_o,
    output logic         branch_o,
    output logic         jal_o,
    output logic         jalr_o,
    output logic         mret_o
);
    import decoder_pkg::*;
    
    logic [6 :0] funct7;
    logic [2 :0] funct3;
    logic [6 :0] opcode;
    logic [4 :0] rd;
    
    assign funct7 = fetched_instr_i[31:25];
    assign funct3 = fetched_instr_i[14:12];
    assign opcode = fetched_instr_i[ 6: 0];
    assign rd     = fetched_instr_i[11: 7];
    
    always_comb begin
        case (opcode)
            7'b0110011: begin
                case(funct3)
                    3'h0: begin
                        case (funct7)
                            7'h00: begin
                                //add
                                a_sel_o  = OP_A_RS1;
                                b_sel_o  = OP_B_RS2;
                                alu_op_o = ALU_ADD;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = WB_EX_RESULT;
                                gpr_we_o = 1;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 0;
                            end
                            7'h20: begin
                                //sub
                                a_sel_o  = OP_A_RS1;
                                b_sel_o  = OP_B_RS2;
                                alu_op_o = ALU_SUB;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = WB_EX_RESULT;
                                gpr_we_o = 1;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 0;
                            end
                            default: begin
                                a_sel_o  = 0;
                                b_sel_o  = 0;
                                alu_op_o = 0;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = 0;
                                gpr_we_o = 0;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 1;
                            end
                        endcase
                    end
                    3'h1: begin
                        if (funct7 == 0) begin
                            //sll
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_RS2;
                            alu_op_o = ALU_SLL;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h2: begin
                        if (funct7 == 0) begin
                            //slt
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_RS2;
                            alu_op_o = ALU_SLTS;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h3: begin
                        if (funct7 == 0) begin
                            //sltu
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_RS2;
                            alu_op_o = ALU_SLTU;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h4: begin
                        if (funct7 == 0) begin
                            //xor
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_RS2;
                            alu_op_o = ALU_XOR;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h5: begin
                       case (funct7)
                            7'h00: begin
                                //srl
                                a_sel_o  = OP_A_RS1;
                                b_sel_o  = OP_B_RS2;
                                alu_op_o = ALU_SRL;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = WB_EX_RESULT;
                                gpr_we_o = 1;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 0;
                            end
                            7'h20: begin
                                //sra
                                a_sel_o  = OP_A_RS1;
                                b_sel_o  = OP_B_RS2;
                                alu_op_o = ALU_SRA;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = WB_EX_RESULT;
                                gpr_we_o = 1;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 0;
                            end
                            default: begin
                                a_sel_o  = 0;
                                b_sel_o  = 0;
                                alu_op_o = 0;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = 0;
                                gpr_we_o = 0;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 1;
                            end
                        endcase
                    end
                    3'h6: begin
                        if (funct7 == 0) begin
                            //or
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_RS2;
                            alu_op_o = ALU_OR;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h7: begin
                        if (funct7 == 0) begin
                            //and
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_RS2;
                            alu_op_o = ALU_AND;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    default: begin
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 1;
                    end
                endcase
            end
            7'b0010011: begin
                case(funct3)
                    3'h0: begin
                        //addi
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_EX_RESULT;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h1: begin
                        if (funct7 == 0) begin
                            //slli
                            a_sel_o  = OP_A_RS1;
                            b_sel_o  = OP_B_IMM_I;
                            alu_op_o = ALU_SLL;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = WB_EX_RESULT;
                            gpr_we_o = 1;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 0;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h2: begin
                        //slti
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_SLTS;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_EX_RESULT;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h3: begin
                        //sltiu
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_SLTU;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_EX_RESULT;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h4: begin
                        //xori
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_XOR;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_EX_RESULT;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h5: begin
                        case (funct7)
                            7'h00: begin
                                //srli
                                a_sel_o  = OP_A_RS1;
                                b_sel_o  = OP_B_IMM_I;
                                alu_op_o = ALU_SRL;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = WB_EX_RESULT;
                                gpr_we_o = 1;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 0;
                            end
                            7'h20: begin
                                //srai
                                a_sel_o  = OP_A_RS1;
                                b_sel_o  = OP_B_IMM_I;
                                alu_op_o = ALU_SRA;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = WB_EX_RESULT;
                                gpr_we_o = 1;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 0;
                            end
                            default: begin
                                a_sel_o  = 0;
                                b_sel_o  = 0;
                                alu_op_o = 0;
                                csr_op_o = 0;
                                csr_we_o = 0;
                                mem_req_o = 0;
                                mem_we_o = 0;
                                mem_size_o = 0;
                                wb_sel_o = 0;
                                gpr_we_o = 0;
                                branch_o = 0;
                                jal_o = 0;
                                jalr_o = 0;
                                mret_o = 0;
                                illegal_instr_o = 1;
                            end
                        endcase
                    end
                    3'h6: begin
                        //ori
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_OR;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_EX_RESULT;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h7: begin
                        //andi
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_AND;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_EX_RESULT;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    default: begin
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 1;
                    end
                endcase
            end
            7'b0000011: begin
                case(funct3)
                    3'h0: begin 
                        //lb
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 0;
                        mem_size_o = 3'b000;
                        wb_sel_o = WB_LSU_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h1: begin
                        //lh
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 0;
                        mem_size_o = 3'b001;
                        wb_sel_o = WB_LSU_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h2: begin
                        //lw
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 0;
                        mem_size_o = 3'b010;
                        wb_sel_o = WB_LSU_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h4: begin
                        //lbu
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 0;
                        mem_size_o = 3'b100;
                        wb_sel_o = WB_LSU_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h5: begin
                        //lhu
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_I;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 0;
                        mem_size_o = 3'b101;
                        wb_sel_o = WB_LSU_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    default: begin
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 1;
                    end
                endcase
            end
            7'b0100011: begin
                case(funct3)
                    3'h0: begin
                        //sb
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_S;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 1;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h1: begin
                        //sh
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_S;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 1;
                        mem_size_o = 3'b001;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h2: begin
                        //sw
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_IMM_S;
                        alu_op_o = ALU_ADD;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 1;
                        mem_we_o = 1;
                        mem_size_o = 3'b010;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    default: begin
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 1;
                    end
                endcase
            end
            7'b1100011: begin
                case(funct3)
                    3'h0: begin
                        //beq
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_RS2;
                        alu_op_o = ALU_EQ;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 1;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h1: begin
                        //bne
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_RS2;
                        alu_op_o = ALU_NE;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 1;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h4: begin
                        //blt
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_RS2;
                        alu_op_o = ALU_LTS;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 1;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h5: begin
                        //bge
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_RS2;
                        alu_op_o = ALU_GES;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 1;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h6: begin
                        //bltu
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_RS2;
                        alu_op_o = ALU_LTU;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 1;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h7: begin
                        //bgeu
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = OP_B_RS2;
                        alu_op_o = ALU_GEU;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 1;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    default: begin
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 1;
                    end
                endcase
            end
            7'b1101111: begin
                //jal
                a_sel_o  = OP_A_CURR_PC;
                b_sel_o  = OP_B_INCR;
                alu_op_o = ALU_ADD;
                csr_op_o = 0;
                csr_we_o = 0;
                mem_req_o = 0;
                mem_we_o = 0;
                mem_size_o = 0;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1;
                branch_o = 0;
                jal_o = 1;
                jalr_o = 0;
                mret_o = 0;
                illegal_instr_o = 0;
            end
            7'b1100111: begin
                if(funct3 == 0) begin
                    //jalr
                    a_sel_o  = OP_A_CURR_PC;
                    b_sel_o  = OP_B_INCR;
                    alu_op_o = ALU_ADD;
                    csr_op_o = 0;
                    csr_we_o = 0;
                    mem_req_o = 0;
                    mem_we_o = 0;
                    mem_size_o = 0;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1;
                    branch_o = 0;
                    jal_o = 0;
                    jalr_o = 1;
                    mret_o = 0;
                    illegal_instr_o = 0;
                end
                else begin
                    a_sel_o  = 0;
                    b_sel_o  = 0;
                    alu_op_o = 0;
                    csr_op_o = 0;
                    csr_we_o = 0;
                    mem_req_o = 0;
                    mem_we_o = 0;
                    mem_size_o = 0;
                    wb_sel_o = 0;
                    gpr_we_o = 0;
                    branch_o = 0;
                    jal_o = 0;
                    jalr_o = 0;
                    mret_o = 0;
                    illegal_instr_o = 1;
                end
            end
            7'b0110111: begin
                //lui
                a_sel_o  = OP_A_ZERO;
                b_sel_o  = OP_B_IMM_U;
                alu_op_o = ALU_ADD;
                csr_op_o = 0;
                csr_we_o = 0;
                mem_req_o = 0;
                mem_we_o = 0;
                mem_size_o = 0;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1;
                branch_o = 0;
                jal_o = 0;
                jalr_o = 0;
                mret_o = 0;
                illegal_instr_o = 0;
            end
            7'b0010111: begin
                //auipc
                a_sel_o  = OP_A_CURR_PC;
                b_sel_o  = OP_B_IMM_U;
                alu_op_o = ALU_ADD;
                csr_op_o = 0;
                csr_we_o = 0;
                mem_req_o = 0;
                mem_we_o = 0;
                mem_size_o = 0;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1;
                branch_o = 0;
                jal_o = 0;
                jalr_o = 0;
                mret_o = 0;
                illegal_instr_o = 0;
            end
            7'b0001111: begin
                if (funct3 == 0) begin
                    //fence
                    a_sel_o  = 0;
                    b_sel_o  = 0;
                    alu_op_o = 0;
                    csr_op_o = 0;
                    csr_we_o = 0;
                    mem_req_o = 0;
                    mem_we_o = 0;
                    mem_size_o = 0;
                    wb_sel_o = 0;
                    gpr_we_o = 0;
                    branch_o = 0;
                    jal_o = 0;
                    jalr_o = 0;
                    mret_o = 0;
                    illegal_instr_o = 0;
                end
                else begin
                    a_sel_o  = 0;
                    b_sel_o  = 0;
                    alu_op_o = 0;
                    csr_op_o = 0;
                    csr_we_o = 0;
                    mem_req_o = 0;
                    mem_we_o = 0;
                    mem_size_o = 0;
                    wb_sel_o = 0;
                    gpr_we_o = 0;
                    branch_o = 0;
                    jal_o = 0;
                    jalr_o = 0;
                    mret_o = 0;
                    illegal_instr_o = 1;
                end
            end
            7'b1110011: begin
                case(funct3)
                    3'h0: begin
                        if (fetched_instr_i == 32'b0011000_00010_00000_000_00000_1110011) begin
                            //mret
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 1;
                            illegal_instr_o = 0;
                        end
                        else if (fetched_instr_i == 32'b0000000_00010_00000_000_00000_1110011) begin
                            //ecall
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                        else if (fetched_instr_i == 32'b0000000_00010_00000_000_00000_1110011) begin
                            //ebreak
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                        else begin
                            a_sel_o  = 0;
                            b_sel_o  = 0;
                            alu_op_o = 0;
                            csr_op_o = 0;
                            csr_we_o = 0;
                            mem_req_o = 0;
                            mem_we_o = 0;
                            mem_size_o = 0;
                            wb_sel_o = 0;
                            gpr_we_o = 0;
                            branch_o = 0;
                            jal_o = 0;
                            jalr_o = 0;
                            mret_o = 0;
                            illegal_instr_o = 1;
                        end
                    end
                    3'h1: begin
                        //csrrw
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = CSR_RW;
                        csr_we_o = 1;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_CSR_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h2: begin
                        //csrrs
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = CSR_RS;
                        csr_we_o = 1;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_CSR_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h3: begin
                        //csrrc
                        a_sel_o  = OP_A_RS1;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = CSR_RC;
                        csr_we_o = 1;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_CSR_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h5: begin
                        //csrrwi
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = CSR_RWI;
                        csr_we_o = 1;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_CSR_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h6: begin
                        //csrrsi
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = CSR_RSI;
                        csr_we_o = 1;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_CSR_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    3'h7: begin
                        //csrrci
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = CSR_RCI;
                        csr_we_o = 1;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = WB_CSR_DATA;
                        gpr_we_o = 1;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 0;
                    end
                    default: begin
                        a_sel_o  = 0;
                        b_sel_o  = 0;
                        alu_op_o = 0;
                        csr_op_o = 0;
                        csr_we_o = 0;
                        mem_req_o = 0;
                        mem_we_o = 0;
                        mem_size_o = 0;
                        wb_sel_o = 0;
                        gpr_we_o = 0;
                        branch_o = 0;
                        jal_o = 0;
                        jalr_o = 0;
                        mret_o = 0;
                        illegal_instr_o = 1;
                    end
                endcase
            end
            default: begin
                a_sel_o  = 0;
                b_sel_o  = 0;
                alu_op_o = 0;
                csr_op_o = 0;
                csr_we_o = 0;
                mem_req_o = 0;
                mem_we_o = 0;
                mem_size_o = 0;
                wb_sel_o = 0;
                gpr_we_o = 0;
                branch_o = 0;
                jal_o = 0;
                jalr_o = 0;
                mret_o = 0;
                illegal_instr_o = 1;
            end
        endcase
    end
    
endmodule