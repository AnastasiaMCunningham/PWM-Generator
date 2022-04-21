`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: https://github.com/AnastasiaMCunningham
// Engineer: Anastasia Cunningham
// 
// Create Date: 04/20/2022 03:52:43 PM
// Design Name: PWM Generator
// Module Name: PWMGenTop
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


module PWMGenTop #(
    parameter PhaseCount = 3,
    parameter InterleaveCount = 4,
    parameter LevelCount = 2,
    parameter BIT_WIDTH = 16
)
(
    input MClk,
    input RstN,
    input [BIT_WIDTH-1:0] Compare,
    input [BIT_WIDTH-1:0] PWMMaxCount,
    input [BIT_WIDTH-1:0] TriangleStepSize,
    input [BIT_WIDTH-1:0] DeadTimeCount,
    output [(PhaseCount*InterleaveCount*LevelCount*2)-1:0] S
    );

    generate 
        for (genvar i=0; i < PhaseCount; i = i+1) begin
            PhaseX #(InterleaveCount, LevelCount, BIT_WIDTH) pX (MClk, RstN, Compare, PWMMaxCount, TriangleStepSize, DeadTimeCount, S[((i+1)*(InterleaveCount*LevelCount*2))-1:(i*InterleaveCount*LevelCount*2)]);
        end
    endgenerate

endmodule

