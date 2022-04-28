`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 08:38:47 AM
// Design Name: 
// Module Name: PWMGenTop_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWMGenTop_tb;

    parameter PhaseCount = 3;
    parameter InterleaveCount = 4;
    parameter LevelCount = 2;
    parameter BIT_WIDTH = 16;

    logic MClk, RstN;
    logic [BIT_WIDTH-1:0] Compare [PhaseCount-1:0];
    logic [BIT_WIDTH-1:0] PWMMaxCount, TriangleStepSize, DeadTimeCount;
    logic [(PhaseCount*InterleaveCount*LevelCount*2)-1:0] S;
    
    
    PWMGenTop #(PhaseCount, InterleaveCount, LevelCount, BIT_WIDTH) uut(MClk, RstN, Compare, PWMMaxCount, TriangleStepSize, DeadTimeCount, S);
    
    always begin
        MClk = 1'b1;
        #20;
        MClk = 1'b0;
        #20;
    end
    
    always@(posedge MClk) begin
        RstN = 1'b0;
        Compare[0] = 300;
        Compare[1] = 150;
        Compare[2] = 600;
        PWMMaxCount = 500;
        TriangleStepSize = 2;
        DeadTimeCount = 5;
        
        #100;
        
        RstN = 1'b1;
        
        #100000;
       
        
        RstN = 1'b0;
        
        
        #1000000
    
    
    $stop;
    end

endmodule
