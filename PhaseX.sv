`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: https://github.com/AnastasiaMCunningham
// Engineer: Anastasia Cunningham
// 
// Create Date: 04/20/2022 03:52:43 PM
// Design Name: PWM Generator
// Module Name: PhaseX
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


module PhaseX #(
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
    output [(InterleaveCount*LevelCount*2)-1:0] S
    );
    
    logic [BIT_WIDTH-1:0] Interleave [0:15] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}; //convert to non-hardcoded if possible

    generate 
        for (genvar i=0; i < InterleaveCount; i = i+1) begin
            InterleaveX #(InterleaveCount, LevelCount, BIT_WIDTH) iX (MClk, RstN, Interleave[i], Compare, PWMMaxCount, TriangleStepSize, DeadTimeCount, S[((i+1)*(LevelCount*2))-1:(i*LevelCount*2)]);
        end
    endgenerate

endmodule

