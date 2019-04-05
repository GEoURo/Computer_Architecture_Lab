`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB (Embeded System Lab)
// Engineer: Haojun Xia
// Create Date: 2019/02/08
// Design Name: RISCV-Pipline CPU
// Module Name: ImmOperandUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Generate different type of Immediate Operand
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module ImmOperandUnit(
    input wire [31:7] In,
    input wire [2:0] Type,
    output reg [31:0] Out
    );
    //
    always@(*)
    begin
        case(Type)
            `ITYPE: Out <= { {21{In[31]}}, In[30:20] };
            `RTYPE: Out <= 32'b0;
            `STYPE: Out <= { {21{In[31]}}, In[30:25], In[11:7] };
            `BTYPE: Out <= { {20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0 };
            `UTYPE: Out <= { In[31:12], 12'b0 };
            `JTYPE: Out <= { {12{In[31]}}, In[19:12], In[20], In[30:21], 1'b0 };
            default:Out <= 32'hxxxxxxxx;
        endcase
    end
    
endmodule

//功能说明
    //ImmOperandUnit利用正在被译码的指令的部分编码�?�，生成不同类型�?32bit立即�?
//输入
    //IN        是指令除了opcode以外的部分编码�??
    //Type      表示立即数编码类型，全部类型定义在Parameters.v�?
//输出
    //OUT       表示指令对应的立即数32bit实际�?