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


module LevelX#(
    parameter LevelCount = 2,
    parameter Level = 1 //varies from 0 to LevelCount-1
)
(
    input MClk,
    input RstN,
    input [15:0] Compare,
    input [15:0] PWMMaxCount,
    input [15:0] TriangleStepSize,
    input [15:0] DeadTimeCount,
    output [1:0] S //PWM output and inverse
    );
    
    logic [15:0] UpperLimit = PWMMaxCount;
    logic [15:0] LowerLimit = 0;
    logic [15:0] TWave = 0;
    logic [15:0] TWaveRange = PWMMaxCount;
    logic [1:0] SPDT; //S Pre-Dead Time
    
    //Calculate UpperLimit and LowerLimit based on Level, LevelCount, and PWMMaxCount
    assign TWaveRange = PWMMaxCount/LevelCount; //Use module, not good practice to use /
    assign LowerLimit = Level*TWaveRange;
    assign UpperLimit = ((Level+1)*TWaveRange)-1;

    
    //Generate Triangle Wave(TWave) based on UpperLimit and Lower Limit
    TriangleWaveGen trigen (MClk, RstN, UpperLimit, LowerLimit, TriangleStepSize, TWave);

    //Compare Compare input to TWave to get S1 Pre-DeadTime
    assign SPDT[0] = (Compare > TWave); 
    assign SPDT[1] = ~SPDT[0];
    
    //Pass S1 through DeadTimer to get S2
    DeadTimer dt (MClk, RstN, DeadTimeCount, SPDT, S); 
    
endmodule