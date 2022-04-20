`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: https://github.com/AnastasiaMCunningham
// Engineer: Anastasia Cunningham
// 
// Create Date: 04/20/2022 03:52:43 PM
// Design Name: PWM Generator
// Module Name: InterleaveX
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


module InterleaveX #(
    parameter LevelCount = 2
)
(
    input MClk,
    input RstN,
    input [15:0] Compare,
    input [15:0] PWMMaxCount,
    input [15:0] TriangleStepSize,
    input [15:0] DeadTimeCount,
    output [(LevelCount*2)-1:0] S
    );

    generate 
        for (i=0; i < LevelCount; i = i+1) begin
            LevelX #(.LevelCount(LevelCount), .Level(i)) lX (MClk, RstN, Compare, PWMMaxCount, TriangleStepSize, DeadTimeCount, S[((i+1)*(2))-1:(i*2)]);
        end
    endgenerate

endmodule