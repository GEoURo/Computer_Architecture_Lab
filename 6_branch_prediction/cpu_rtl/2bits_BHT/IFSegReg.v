`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB£¨Embeded System Lab£©
// Engineer: Haojun Xia
// Create Date: 2019/02/08
// Design Name: RISCV-Pipline CPU
// Module Name: IFSegReg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: PC Register
//////////////////////////////////////////////////////////////////////////////////
module IFSegReg(
    input wire clk,
    input wire en, clear,
    input wire [31:0] PC_In,
	input wire [1:0] BranchFlags,
	input wire [2:0] BranchIndex,
    output reg [31:0] PCF,
	output reg [1:0] BranchFlagsF,
	output reg [2:0] BranchIndexF
    );
    initial PCF = 0;
    
    always@(posedge clk)
        if(en) begin
            if(clear)
            begin
                PCF <= 0;
				BranchFlagsF <= 2'b0;
				BranchIndexF <= 3'b0;
			end
            else 
            begin
                PCF <= PC_In;
				BranchFlagsF <= BranchFlags;
				BranchIndexF <= BranchIndex;
			end
        end
	
endmodule