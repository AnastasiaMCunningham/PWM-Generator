`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: https://github.com/AnastasiaMCunningham
// Engineer: Anastasia Cunningham
// 
// Create Date: 04/20/2022 03:52:43 PM
// Design Name: PWM Generator
// Module Name: LevelX
// Project Name: PWM Generator - SystemVerilog
// Target Devices: Zedboard
// Tool Versions: Vivado 2021.2
// Description: 
// 
// Dependencies: 
// 
// Revision: 0.02 - Initial Design
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LevelX #(
    parameter LevelCount = 2,
    parameter BIT_WIDTH = 16
//    parameter Level = 1 //varies from 0 to LevelCount-1
)
(
    input MClk,
    input RstN,
    input [BIT_WIDTH-1:0] Level,
    input [BIT_WIDTH-1:0] Compare,
    input [BIT_WIDTH-1:0] PWMMaxCount,
    input [BIT_WIDTH-1:0] TriangleStepSize,
    input [BIT_WIDTH-1:0] DeadTimeCount,
    output [1:0] S //PWM output and inverse
    );
    
    logic [BIT_WIDTH-1:0] UpperLimit = PWMMaxCount;
    logic [BIT_WIDTH-1:0] LowerLimit = 0;
    logic [BIT_WIDTH-1:0] TWave = 0;
    logic  [1:0] SPDT; // S Pre-Dead Time
    logic [BIT_WIDTH-1:0] divisor = PWMMaxCount;
    logic [BIT_WIDTH-1:0] divResult = 0;
    logic TWaveEn = 0;
    logic TWaveEnFlag = 0;
    logic DivDoneFlag = 0;
    
    
    //Calculate UpperLimit and LowerLimit based on Level, LevelCount, and PWMMaxCount
    //-- TWaveRange = PWMMaxCount/LevelCount;
    always@(*) begin
        if(~RstN) begin
            divisor <= PWMMaxCount;
            divResult <= 0;
            DivDoneFlag <= 0;
        end
        else begin
            if(divisor >= LevelCount) begin
                divisor <= divisor - LevelCount;
                divResult <= divResult+1;
                DivDoneFlag <= 0;
            end
            else begin
                DivDoneFlag <= 1;
            end
        end
    end
    
    always_ff @ (posedge MClk) begin
        if(DivDoneFlag & ~TWaveEnFlag) begin //only should be entered once per reset
                LowerLimit = Level*divResult;
                UpperLimit = ((Level+1)*divResult)-1;
                TWaveEn <= 0;
                TWaveEnFlag <= 1;
        end
        else if (TWaveEnFlag) begin
            TWaveEn <= 1;
        end
    end

    
    //Generate Triangle Wave(TWave) based on UpperLimit and Lower Limit
    TriangleWaveGen #(BIT_WIDTH) trigen (.MClk(MClk), .RstN(RstN), .En(TWaveEn), .UpperLimit(UpperLimit), .LowerLimit(LowerLimit), .StepSize(TriangleStepSize), .TWave(TWave));

    //Compare Compare input to TWave to get S1 Pre-DeadTime
    assign SPDT[0] = (Compare > TWave); 
    assign SPDT[1] = ~SPDT[0];
    
    //Pass S1 through DeadTimer to get S2
    DeadTimer #(BIT_WIDTH) dt (MClk, RstN, DeadTimeCount, SPDT, S); 
    
endmodule