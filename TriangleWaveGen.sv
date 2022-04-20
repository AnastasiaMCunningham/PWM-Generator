`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 04:30:27 PM
// Design Name: 
// Module Name: TriangleWaveGen
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


module TriangleWaveGen(
    input MClk,
    input RstN,
    input [15:0] UpperLimit,
    input [15:0] LowerLimit,
    input [15:0] TriangleStepSize,
    output [15:0] TWave
    );

    logic [15:0] TWaveReg = LowerLimit; //Start from bottom
    logic UpDn = 1; //Start counting up
    
    assign TWave = TWaveReg;
    
    always_ff @ (posedge MClk) begin
        if(~RstN) begin
            TWaveReg <= LowerLimit;
            UpDn <= 1;
        end
        else begin
            if(UpDn) begin //counting up
                if(TWaveReg + TriangleStepSize > UpperLimit) begin //overflow detection
                    TWaveReg <= UpperLimit - (TriangleStepSize - (UpperLimit - TWaveReg)); //overflow of TWaveReg is subtracted from upper limit
                    UpDn <= 0; //change direction
                end
                else begin
                    TWaveReg <= TWaveReg+TriangleStepSize;
                end            
            end
            else begin //counting down
                if(TWaveReg - LowerLimit < TriangleStepSize) begin //underflow detection
                    TWaveReg <= TriangleStepSize - (TWaveReg - LowerLimit) + LowerLimit; //underflow of TWaveReg is added to lower limit for new TWaveReg
                    UpDn <= 1; //change direction
                end
                else begin
                    TWaveReg <= TWaveReg-TriangleStepSize;            
                end
            end        
        end
    end 


endmodule

