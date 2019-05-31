`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB（Embeded System Lab�?
// Engineer: Haojun Xia
// Create Date: 2019/03/14 11:21:33
// Design Name: RISCV-Pipline CPU
// Module Name: NPC_Generator
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Choose Next PC value
//////////////////////////////////////////////////////////////////////////////////
module NPC_Generator(
    input clk,
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,
	input wire [1:0] BranchFlagsF,
	input wire [2:0] BranchIndexF,
	input wire [31:0] PCE,
	input wire [1:0] BranchE,
	input wire [1:0] BranchFlagsE,
	input wire [2:0] BranchIndexE,
    input wire JalD,JalrE,CpuRst,
    output reg [31:0] PC_In,
	output reg [1:0] BranchFlags,
	output reg [2:0] BranchIndex
    );
	
	reg [31:0] BranchPC [0:7];
	reg [31:0] BranchPredPC [0:7];
	reg [1:0] PredEn[0:7];
	reg [2:0] indexNum;
	integer i;
	
    always @(*)
    begin
        if(JalrE)
            PC_In <= JalrTarget;
        else if(BranchE == 2'b01 || BranchE == 2'b10)//ƥ�������ʧ�ܣ�����֧�ɹ�����ʹ��BranchTarget��ΪNPC
            PC_In <= BranchTarget;
		else if(BranchE == 2'b11)//���гɹ�������֧ʧ�ܣ���ʹ��BranchPC + 4��ΪNPC
			PC_In <= BranchPC[BranchIndexE] + 4;
        else if(JalD)
            PC_In <= JalTarget;
        else if(BranchFlagsF == 2'b11)
			PC_In <= BranchPredPC[BranchIndexF];
		else
            PC_In <= PCF+4;
    end
	
	always @(*)
	begin
		if(CpuRst)
		begin
            BranchFlags = 2'b00;
            BranchIndex = 3'b000;
		end
		else 
		begin
			BranchFlags = 2'b00;
			BranchIndex = 3'b000;
			for(i = 0; i < 8; i=i+1)
			begin
				if(PC_In == BranchPC[i])
				begin
					BranchFlags[0] = 1'b1;
					if(PredEn[i][1] == 1'b1)
						BranchFlags[1] = 1'b1;
					BranchIndex = i;
				end
			end
		end
	end
	
	always@(posedge clk)
	begin
	    if(CpuRst)
	    begin
	        indexNum <= 3'b0;
            for(i = 0; i < 8; i=i+1)
            begin
                BranchPC[i] <= 32'b0;
                BranchPredPC[i] <= 32'b0;
                PredEn[i] <= 2'b0;
            end
	    end
	    else
	    begin
	        if(BranchE == 2'b00)
	        begin
	            if(BranchFlagsE[0] == 1'b1)//��Ԥ��ɹ�
	            begin
	               if(PredEn[BranchIndexE] == 2'b01)
	                   PredEn[BranchIndexE] <= 2'b00;
	               else if(PredEn[BranchIndexE] == 2'b10)
	                   PredEn[BranchIndexE] <= 2'b11;
	               else
	                   PredEn[BranchIndexE] <= PredEn[BranchIndexE];
	            end
	        end
            else if(BranchE == 2'b01)//ƥ��ʧ�ܣ�����֧�ɹ��������µı���
            begin
                BranchPC[indexNum] <= PCE;
                BranchPredPC[indexNum] <= BranchTarget;
                PredEn[indexNum] <= 2'b10;
                indexNum <= indexNum + 1;
            end
            else if(BranchE == 2'b10)//ƥ��ɹ�������ʧ�ܣ�����֧�ɹ������轫�ñ���ʹ��
            begin
                if(PredEn[BranchIndexE] == 2'b00)
                    PredEn[BranchIndexE] <= 2'b01;
                else if(PredEn[BranchIndexE] == 2'b01)
                    PredEn[BranchIndexE] <= 2'b11;
                else
                    PredEn[BranchIndexE] <= PredEn[BranchIndexE];
            end
            else if(BranchE == 2'b11)//ƥ��ɹ������гɹ�������֧ʧ�ܣ��轫�ñ�����Ϊ��Ч
            begin
                if(PredEn[BranchIndexE] == 2'b10)
                    PredEn[BranchIndexE] <= 2'b00;
                else if(PredEn[BranchIndexE] == 2'b11)
                    PredEn[BranchIndexE] <= 2'b10;
                else
                    PredEn[BranchIndexE] <= PredEn[BranchIndexE];
            end
        end
	end
	
endmodule
