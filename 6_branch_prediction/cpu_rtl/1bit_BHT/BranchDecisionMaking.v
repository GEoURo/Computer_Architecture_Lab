`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB（Embeded System Lab�?
// Engineer: Haojun Xia
// Create Date: 2019/03/14 12:03:15
// Design Name: RISCV-Pipline CPU
// Module Name: BranchDecisionMaking
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Decide whether to branch 
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module BranchDecisionMaking(
	input wire [1:0] BranchFlagsE,
    input wire [2:0] BranchTypeE,
    input wire [31:0] Operand1,Operand2,
    output reg [1:0] BranchE
    );
wire signed [31:0] Operand1S = $signed(Operand1);
wire signed [31:0] Operand2S = $signed(Operand2);
    //
	reg Branch;
	
    always@(*)
    case(BranchTypeE)
//分支预测
    `BEQ:    if(Operand1==Operand2)      Branch<=1'b1;  //BEQ
            else                        Branch<=1'b0;
    `BNE:    if(Operand1!=Operand2)      Branch<=1'b1;  //BNE
            else                        Branch<=1'b0;   
    `BLT:    if(Operand1S<Operand2S)     Branch<=1'b1;  //BLT
            else                        Branch<=1'b0;
    `BLTU:   if(Operand1<Operand2)       Branch<=1'b1;  //BLTU
            else                        Branch<=1'b0;
    `BGE:    if(Operand1S>=Operand2S)    Branch<=1'b1;  //BGE
            else                        Branch<=1'b0;
    `BGEU:   if(Operand1>=Operand2)      Branch<=1'b1;  //BGEU
            else                        Branch<=1'b0;
    default:                            Branch<=1'b0;  //NOBRANCH                            
    endcase
	
	always@(*)
	begin
		if(BranchFlagsE[0] == 1'b0 && Branch)
			BranchE <= 2'b01;
		else if(BranchFlagsE == 2'b01 && Branch)
			BranchE <= 2'b10;
		else if(BranchFlagsE == 2'b11 && !Branch)
			BranchE <= 2'b11;
		else
			BranchE <= 2'b00;
	end
	
endmodule
