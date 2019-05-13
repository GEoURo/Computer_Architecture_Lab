`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB��Embeded System Lab??
// Engineer: Haojun Xia & Xuan Wang
// Create Date: 2019/02/22
// Design Name: RISCV-Pipline CPU
// Module Name: HarzardUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Deal with harzards in pipline
//////////////////////////////////////////////////////////////////////////////////
module HarzardUnit(
    input wire CpuRst, ICacheMiss, DCacheMiss, 
    input wire BranchE, JalrE, JalD, 
    input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input wire [1:0] RegReadE,
    input wire [2:0] MemToRegE, RegWriteM, RegWriteW,
    output reg StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW,
    output reg [1:0] Forward1E, Forward2E
    );
    //Stall and Flush signals generate
    always@(*)
    begin
        if(DCacheMiss)
        begin
            StallF <= 1'b1;
            StallD <= 1'b1;
            StallE <= 1'b1;
            StallM <= 1'b1;
            StallW <= 1'b1;
        end
        else if((Rs1D == RdE || Rs2D == RdE) && MemToRegE[0] == 1'b1)
        begin
            StallF <= 1'b1;
            StallD <= 1'b1;
            StallE <= 1'b0;
            StallM <= 1'b0;
            StallW <= 1'b0;
        end
        else
        begin
            StallF <= 1'b0;
            StallD <= 1'b0;
            StallE <= 1'b0;
            StallM <= 1'b0;
            StallW <= 1'b0;
        end
    end

    always@(*)
    begin
        if(CpuRst)
        begin
            FlushF <= 1'b1;
            FlushD <= 1'b1;
            FlushE <= 1'b1;
            FlushM <= 1'b1;
            FlushW <= 1'b1;
        end
        else if(BranchE || JalrE)
        begin
            FlushF <= 1'b0;
            FlushD <= 1'b1;
            FlushE <= 1'b1;
            FlushM <= 1'b0;
            FlushW <= 1'b0;
        end
        else if(JalD)
        begin
            FlushF <= 1'b0;
            FlushD <= 1'b1;
            FlushE <= 1'b0;
            FlushM <= 1'b0;
            FlushW <= 1'b0;
        end
        else
        begin
            FlushF <= 1'b0;
            FlushD <= 1'b0;
            FlushE <= 1'b0;
            FlushM <= 1'b0;
            FlushW <= 1'b0;
        end
    end

    //Forward Register Source 1
    always@(*)
    begin
        if(RegReadE[1] == 1'b1)
        begin
            if(RegWriteM != `NOREGWRITE && RdM != 5'b0 && Rs1E == RdM)                     //Forwarding from Mem
                Forward1E <= 2'b10;
            else if(RegWriteW != `NOREGWRITE && RdW != 5'b0 && Rs1E != RdM && Rs1E == RdW) //Forwarding from WB
                Forward1E <= 2'b01;
            else
                Forward1E <= 2'b00;
        end
        else    Forward1E <= 2'b00;
    end
    //Forward Register Source 2
    always@(*)
    begin
        if(RegReadE[0] == 1'b1)
        begin
            if(RegWriteM != `NOREGWRITE && RdM != 5'b0 && Rs2E == RdM)                     //Forwarding from Mem
                Forward2E <= 2'b10;
            else if(RegWriteW != `NOREGWRITE && RdW != 5'b0 && Rs2E != RdM && Rs2E == RdW) //Forwarding from WB
                Forward2E <= 2'b01;
            else
                Forward2E <= 2'b00;
        end
        else    Forward2E <= 2'b00;
    end
endmodule

//����˵��
    //HarzardUnit����������ˮ�߳�ͻ��ͨ���������ݣ�forward�Լ���ˢ��ˮ�ν��������غͿ�����أ����???����·
    //����??��ʵ��???ǰ�ڲ���CPU��ȷ��ʱ��������ÿ����ָ������������ָ�Ȼ��ֱ�Ӱѱ�ģ�������Ϊ����forward����stall����flush 
//����
    //CpuRst                                    �ⲿ�źţ�������ʼ��CPU����CpuRst==1ʱCPUȫ�ָ�λ���㣨���жμĴ���flush����Cpu_Rst==0ʱcpu??ʼִ��ָ??
    //ICacheMiss, DCacheMiss                    Ϊ����ʵ��Ԥ���źţ���ʱ�������ӣ���������cache miss
    //BranchE, JalrE, JalD                      ��������������
    //Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW     ��������������أ��ֱ��ʾԴ�Ĵ�??1���룬Դ�Ĵ�??2���룬Ŀ��Ĵ�������
    //RegReadE RegReadE[1]==1                   ��ʾA1��Ӧ�ļĴ���ֵ��ʹ�õ��ˣ�RegReadD[0]==1��ʾA2��Ӧ�ļĴ���ֵ��ʹ�õ��ˣ�����forward�Ĵ�??
    //RegWriteM, RegWriteW                      ��������������أ�RegWrite!=3'b0˵����Ŀ��Ĵ�����д���??
    //MemToRegE                                 ��ʾEx�ε�ǰָ?? ��Data Memory�м������ݵ��Ĵ�����
//���
    //StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW    ��������μĴ�������stall��ά��״̬���䣩��flush�����㣩
    //Forward1E, Forward2E                                                              ����forward
//ʵ��Ҫ��  
    //ʵ��HarzardUnitģ��   