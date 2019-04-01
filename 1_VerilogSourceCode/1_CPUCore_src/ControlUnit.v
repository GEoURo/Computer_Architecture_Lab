`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB (Embeded System Lab)
// Engineer: Haojun Xia
// Create Date: 2019/02/08
// Design Name: RISCV-Pipline CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output wire JalD,
    output wire JalrD,
    output reg [2:0] RegWriteD,
    output wire MemToRegD,
    output reg [3:0] MemWriteD,
    output wire LoadNpcD,
    output reg [1:0] RegReadD,
    output reg [2:0] BranchTypeD,
    output reg [3:0] AluContrlD,
    output wire [1:0] AluSrc2D,
    output wire AluSrc1D,
    output reg [2:0] ImmType        
    );
    always@(*)
    begin
        case(Op)
            7'b0000011://load type
            begin
                case(Fn3)
                    3'b000://lb
                    begin
                          
                    end
                    3'b001://lh
                    begin
                        
                    end
                    3'b010://lw
                    begin
                        
                    end
                    3'b100://lbu
                    begin
                        
                    end
                    3'b101://lhu
                    begin
                        
                    end
                    default:
                    begin
                        
                    end
                endcase
            end
            7'b0100011://store type
            begin
                case(Fn3)
                    3'b000://sb
                    begin
                        
                    end
                    3'b001://sh
                    begin
                        
                    end
                    3'b010://sw
                    begin
                        
                    end
                    default:
                    begin
                        
                    end
                endcase
            end
            7'b0110011://R-Type Arithmetic
            begin
                case(Fn3)
                    3'b000://add & sub
                    begin
                        case(Fn7)
                            7'b0000000://add
                            begin
                                
                            end
                            7'b0100000://sub
                            begin
                                
                            end
                            default:
                            begin
                                  
                            end
                        endcase
                    end
                    3'b100://xor
                    begin
                        
                    end
                    3'b110://or
                    begin
                        
                    end
                    3'b111://and
                    begin
                        
                    end
                    3'b001://sll
                    begin
                        
                    end
                    3'b101://srl & sra
                    begin
                        case(Fn7)
                            7'b0000000://srl
                            begin
                                
                            end
                            7'b01000000://sra
                            begin
                                
                            end
                            default:
                            begin
                                
                            end
                        endcase
                    end
                    3'b010://slt
                    begin
                        
                    end
                    3'b011://sltu
                    begin
                        
                    end
                    default:
                    begin
                        
                    end
                endcase
            end
            7'b0010011://I-Type Arithmetic
            begin
                case(Fn3)
                    3'b000://addi
                    begin
                        
                    end
                    3'b100://xori
                    begin
                        
                    end
                    3'b110://ori
                    begin
                        
                    end
                    3'b111://andi
                    begin
                        
                    end
                    3'b001://slli
                    begin
                        
                    end
                    3'b101://srli & srai
                    begin
                        case(Fn7)
                            7'b0000000://slli
                            begin
                                
                            end
                            7'b0100000://srai
                            begin
                                
                            end
                            default:
                            begin
                                
                            end
                        endcase
                    end
                    3'b010://slti
                    begin
                        
                    end
                    3'b011://sltiu
                    begin
                        
                    end
                    default:
                    begin
                        
                    end
                endcase
            end
            7'b0110111://lui
            begin
                
            end
            7'b0010111://auipc
            begin
                
            end
            7'b1100011://Branch-Type
            begin
                case(Fn3)
                    3'b000://beq
                    begin
                        
                    end
                    3'b001://bne
                    begin
                        
                    end
                    3'b100://blt
                    begin
                        
                    end
                    3'b101://bge
                    begin
                        
                    end
                    3'b110://bltu
                    begin
                        
                    end
                    3'b111://bgeu
                    begin
                        
                    end
                    default:
                    begin
                    
                    end
                endcase
            end
            7'b1101111://JAL
            begin
                
            end
            7'b1100111://JALR
            begin
                
            end
            default:
            begin
                
            end
        endcase
    end
    
endmodule

//功能说明
    //ControlUnit       是本CPU的指令译码器，组合�?�辑电路
//输入
    // Op               是指令的操作码部�?
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // JalD==1          表示Jal指令到达ID译码阶段
    // JalrD==1         表示Jalr指令到达ID译码阶段
    // RegWriteD        表示ID阶段的指令对应的 寄存器写入模�? ，所有模式定义在Parameters.v�?
    // MemToRegD==1     表示ID阶段的指令需要将data memory读取的�?�写入寄存器,
    // MemWriteD        �?4bit，采用独热码格式，对于data memory�?32bit字按byte进行写入,MemWriteD=0001表示只写入最�?1个byte，和xilinx bram的接口类�?
    // LoadNpcD==1      表示将NextPC输出到ResultM
    // RegReadD[1]==1   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处�?
    // BranchTypeD      表示不同的分支类型，�?有类型定义在Parameters.v�?
    // AluContrlD       表示不同的ALU计算功能，所有类型定义在Parameters.v�?
    // AluSrc2D         表示Alu输入�?2的�?�择
    // AluSrc1D         表示Alu输入�?1的�?�择
    // ImmType          表示指令的立即数格式，所有类型定义在Parameters.v�?   
//实验要求  
    //实现ControlUnit模块   