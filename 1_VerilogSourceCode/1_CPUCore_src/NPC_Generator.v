`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLABï¼ˆEmbeded System Labï¼?
// Engineer: Haojun Xia
// Create Date: 2019/03/14 11:21:33
// Design Name: RISCV-Pipline CPU
// Module Name: NPC_Generator
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Choose Next PC value
//////////////////////////////////////////////////////////////////////////////////
module NPC_Generator(
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,
    input wire BranchE,JalD,JalrE,
    output reg [31:0] PC_In
    );

    always@(*)
    begin
        case({ BranchE, JalrE, JalD })
            3'b100  :   PC_In <= BranchTarget;
            3'b101  :   PC_In <= BranchTarget;  //can be simplified using x'b10x type 
            3'b010  :   PC_In <= JalrTarget;
            3'b011  :   PC_In <= JalrTarget;    //can be simplified using x'b10x type
            3'b001  :   PC_In <= JalTarget;
            3'b000  :   PC_In <= PCF + 4;
            default :   PC_In <= PCF;
        endcase
    end
endmodule
