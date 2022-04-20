`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 05:59:01 PM
// Design Name: 
// Module Name: TriangleWaveGen_tb
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


module TriangleWaveGen_tb(
    );
    
    reg MClk, RstN;
    reg [15:0] UpperLimit, LowerLimit, TriangleStepSize;
    wire [15:0] TWave;  
    
    TriangleWaveGen uut(MClk, RstN, UpperLimit, LowerLimit, TriangleStepSize, TWave);
    
    always begin
        MClk = 1'b1;
        #20;
        MClk = 1'b0;
        #20;
    end
    
    always@(posedge MClk) begin
        RstN = 0;
        UpperLimit = 500;
        LowerLimit = 250;
        TriangleStepSize = 3;
        
        #100;
        
        RstN = 1;
        
        #1000000
    
    
    $stop;
    end
    
endmodule
