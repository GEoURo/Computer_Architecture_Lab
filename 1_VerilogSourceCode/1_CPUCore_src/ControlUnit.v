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

    assign JalD     = (Op == 7'b1101111);   //Jal
    assign JalrD    = (O;p == 7'b1100111);  //Jalr
    assign MemToRegD= (Op == 7'b0000011);   //Load-Type
    assign LoadNpcD = JalD || Jalr;         //Jal or Jalr
    assign AluSrc1D = (Op == 7'b0010111);   //auipc
    assign AluSrc2D = (Op == 7'b0010011) && ((Fn3 == 3'b001) || (Fn3 == 3'b101)) ? 2'b01 : ( (Op == 7'b0110011) || (Op == 7'b1100011) ? 2'b00 : 2'b10 );
    //if slli, srli, srai then 2'b01;
    //else if R-Type Arithmetic or Branch-Type then 2'b00;
    //else 2'b10;

    always@(*)
    begin
        case(Op)
            7'b0000011://load type
            begin
                case(Fn3)
                    3'b000://lb
                    begin
                        RegWriteD   <=  `LB;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `ITYPE;
                    end
                    3'b001://lh
                    begin
                        RegWriteD   <=  `LH;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `ITYPE;
                    end
                    3'b010://lw
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `ITYPE;
                    end
                    3'b100://lbu
                    begin
                        RegWriteD   <=  `LB;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `ITYPE;
                    end
                    3'b101://lhu
                    begin
                        RegWriteD   <=  `LH;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `ITYPE;
                    end
                    default:
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b00;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `RTYPE;
                    end
                endcase
            end
            7'b0100011://store type
            begin
                case(Fn3)
                    3'b000://sb
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0001;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `STYPE;
                    end
                    3'b001://sh
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0011;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `STYPE;
                    end
                    3'b010://sw
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b1111;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `STYPE;
                    end
                    default:
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b00;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `RTYPE;
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
                                RegWriteD   <=  `LW;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b11;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `ADD;
                                ImmType     <=  `RTYPE;
                            end
                            7'b0100000://sub
                            begin
                                RegWriteD   <=  `LW;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b11;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `SUB;
                                ImmType     <=  `RTYPE;
                            end
                            default:
                            begin
                                RegWriteD   <=  `NOREGWRITE;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b00;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `ADD;
                                ImmType     <=  `RTYPE;
                            end
                        endcase
                    end
                    3'b100://xor
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `XOR;
                        ImmType     <=  `RTYPE;
                    end
                    3'b110://or
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `OR;
                        ImmType     <=  `RTYPE;
                    end
                    3'b111://and
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `AND;
                        ImmType     <=  `RTYPE;
                    end
                    3'b001://sll
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `SLL;
                        ImmType     <=  `RTYPE;
                    end
                    3'b101://srl & sra
                    begin
                        case(Fn7)
                            7'b0000000://srl
                            begin
                                RegWriteD   <=  `LW;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b11;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `SRL;
                                ImmType     <=  `RTYPE;
                            end
                            7'b01000000://sra
                            begin
                                RegWriteD   <=  `LW;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b11;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `SRA;
                                ImmType     <=  `RTYPE;
                            end
                            default:
                            begin
                                RegWriteD   <=  `NOREGWRITE;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b00;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `ADD;
                                ImmType     <=  `RTYPE;
                            end
                        endcase
                    end
                    3'b010://slt
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `SLT;
                        ImmType     <=  `RTYPE;
                    end
                    3'b011://sltu
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `SLTU;
                        ImmType     <=  `RTYPE;
                    end
                    default:
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b00;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `RTYPE;
                    end
                endcase
            end
            7'b0010011://I-Type Arithmetic
            begin
                case(Fn3)
                    3'b000://addi
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `ITYPE;
                    end
                    3'b100://xori
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `XOR;
                        ImmType     <=  `ITYPE;
                    end
                    3'b110://ori
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `OR;
                        ImmType     <=  `ITYPE;
                    end
                    3'b111://andi
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `AND;
                        ImmType     <=  `ITYPE;
                    end
                    3'b001://slli
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `SLL;
                        ImmType     <=  `RTYPE;
                    end
                    3'b101://srli & srai
                    begin
                        case(Fn7)
                            7'b0000000://srli
                            begin
                                RegWriteD   <=  `LW;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b10;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `SRL;
                                ImmType     <=  `RTYPE;
                            end
                            7'b0100000://srai
                            begin
                                RegWriteD   <=  `LW;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b10;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `SRA;
                                ImmType     <=  `RTYPE;
                            end
                            default:
                            begin
                                RegWriteD   <=  `NOREGWRITE;
                                MemWrite    <=  4'b0000;
                                RegReadD    <=  2'b00;
                                BranchTypeD <=  `NOBRANCH;
                                AluContrlD  <=  `ADD;
                                ImmType     <=  `RTYPE;
                            end
                        endcase
                    end
                    3'b010://slti
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `SLT;
                        ImmType     <=  `ITYPE;
                    end
                    3'b011://sltiu
                    begin
                        RegWriteD   <=  `LW;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b10;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `SLTU;
                        ImmType     <=  `ITYPE;
                    end
                    default:
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b00;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `RTYPE;
                    end
                endcase
            end
            7'b0110111://lui
            begin
                RegWriteD   <=  `LW;
                MemWrite    <=  4'b0000;
                RegReadD    <=  2'b00;
                BranchTypeD <=  `NOBRANCH;
                AluContrlD  <=  `LUI;
                ImmType     <=  `UTYPE;
            end
            7'b0010111://auipc
            begin
                RegWriteD   <=  `LW;
                MemWrite    <=  4'b0000;
                RegReadD    <=  2'b00;
                BranchTypeD <=  `NOBRANCH;
                AluContrlD  <=  `ADD;
                ImmType     <=  `UTYPE;
            end
            7'b1100011://Branch-Type
            begin
                case(Fn3)
                    3'b000://beq
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `BEQ;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `BTYPE;
                    end
                    3'b001://bne
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `BNE;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `BTYPE;
                    end
                    3'b100://blt
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `BLT;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `BTYPE;
                    end
                    3'b101://bge
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `BGE;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `BTYPE;
                    end
                    3'b110://bltu
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `BLTU;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `BTYPE;
                    end
                    3'b111://bgeu
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b11;
                        BranchTypeD <=  `BGEU;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `BTYPE;
                    end
                    default:
                    begin
                        RegWriteD   <=  `NOREGWRITE;
                        MemWrite    <=  4'b0000;
                        RegReadD    <=  2'b00;
                        BranchTypeD <=  `NOBRANCH;
                        AluContrlD  <=  `ADD;
                        ImmType     <=  `RTYPE;
                    end
                endcase
            end
            7'b1101111://JAL
            begin
                RegWriteD   <=  `LW;
                MemWrite    <=  4'b0000;
                RegReadD    <=  2'b00;
                BranchTypeD <=  `NOBRANCH;
                AluContrlD  <=  `ADD;
                ImmType     <=  `RTYPE;
            end
            7'b1100111://JALR
            begin
                RegWriteD   <=  `LW;
                MemWrite    <=  4'b0000;
                RegReadD    <=  2'b10;
                BranchTypeD <=  `NOBRANCH;
                AluContrlD  <=  `ADD;
                ImmType     <=  `ITYPE;
            end
            default:
            begin
                RegWriteD   <=  `NOREGWRITE;
                MemWrite    <=  4'b0000;
                RegReadD    <=  2'b00;
                BranchTypeD <=  `NOBRANCH;
                AluContrlD  <=  `ADD;
                ImmType     <=  `RTYPE;
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