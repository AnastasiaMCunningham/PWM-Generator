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


module TriangleWaveGen#(
    parameter BIT_WIDTH = 16
)
(
    input MClk,
    input RstN,
    input En,
    input [BIT_WIDTH-1:0] UpperLimit,
    input [BIT_WIDTH-1:0] LowerLimit,
    input [BIT_WIDTH-1:0] StepSize,
    output [BIT_WIDTH-1:0] TWave
    );

    logic [BIT_WIDTH-1:0] TWaveReg = LowerLimit; //Start from bottom
    logic UpDn = 1; //Start counting up
    
    assign TWave = TWaveReg;
    
    always_ff @ (posedge MClk) begin
        if(~RstN | ~En) begin
            TWaveReg <= LowerLimit;
            UpDn <= 1;
        end
        else begin
            if(UpDn) begin //counting up
                if(TWaveReg + StepSize > UpperLimit) begin //overflow detection
                    TWaveReg <= UpperLimit - (StepSize - (UpperLimit - TWaveReg)); //overflow of TWaveReg is subtracted from upper limit
                    UpDn <= 0; //change direction
                end
                else begin
                    TWaveReg <= TWaveReg+StepSize;
                end            
            end
            else begin //counting down
                if(TWaveReg - LowerLimit < StepSize) begin //underflow detection
                    TWaveReg <= StepSize - (TWaveReg - LowerLimit) + LowerLimit; //underflow of TWaveReg is added to lower limit for new TWaveReg
                    UpDn <= 1; //change direction
                end
                else begin
                    TWaveReg <= TWaveReg-StepSize;            
                end
            end        
        end
    end 


endmodule

