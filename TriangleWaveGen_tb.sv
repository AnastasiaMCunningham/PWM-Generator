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
    
    parameter BIT_WIDTH = 16;
    
    reg MClk, RstN, En;
    reg [BIT_WIDTH-1:0] UpperLimit, LowerLimit, StepSize, InterleaveOffset;
    wire [BIT_WIDTH-1:0] TWave;  
    
    TriangleWaveGen #(BIT_WIDTH) uut(MClk, RstN, En, UpperLimit, LowerLimit, StepSize, InterleaveOffset, TWave);
    
    always begin
        MClk = 1'b1;
        #20;
        MClk = 1'b0;
        #20;
    end
    
    always@(posedge MClk) begin
        RstN = 0;
        En = 1;
        InterleaveOffset = 50;
        UpperLimit = 500;
        LowerLimit = 250;
        StepSize = 3;
        
        #100;
        
        RstN = 1;
        
        #1000000
    
    
    $stop;
    end
    
endmodule
