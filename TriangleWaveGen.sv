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
    input [BIT_WIDTH-1:0] InterleaveOffset,
    output [BIT_WIDTH-1:0] TWave
    );

    //determine starting value and direction based on interleave's phase offset
    logic [BIT_WIDTH-1:0] StartVal;
    logic StartDir;
    logic DelayStartFlag1 = 0; //adds up to 1 clock delay to start/reset
    logic DelayStartFlag2 = 0; //adds 1-2 clock delay to start/reset

    always_comb begin
        if(LowerLimit + InterleaveOffset > UpperLimit) begin
            StartVal = UpperLimit - (LowerLimit + InterleaveOffset - UpperLimit); //change direction by subtracting overflow amount by UpperLimit
            StartDir = 0; //counting down
        end
        else begin
            StartVal = LowerLimit + InterleaveOffset;
            StartDir = 1; //counting up
        end
    end

    logic [BIT_WIDTH-1:0] TWaveReg = StartVal;
    logic UpDn = StartDir;
    
    assign TWave = TWaveReg;
    
    always_ff @ (posedge MClk) begin
        if(~RstN | ~En | ~DelayStartFlag1) begin
            TWaveReg <= StartVal;
            UpDn <= StartDir;
            DelayStartFlag1 <= 1; //Only low on start-up to initialize TWaveReg+UpDn
            DelayStartFlag2 <= 0; //Extra delay when starting to calculate StartVal and StartDir before assigning
        end
        else if (~DelayStartFlag2) begin //Extra delay to reassign TWaveReg+UpDn after StartVal+StartDir calculation
            TWaveReg <= StartVal;
            UpDn <= StartDir;
            DelayStartFlag2 <= 1;
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

