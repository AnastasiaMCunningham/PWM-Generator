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
    parameter InterleaveCount = 4,
    parameter LevelCount = 2,
    parameter BIT_WIDTH = 16
)
(
    input MClk,
    input RstN,
    input [BIT_WIDTH-1:0] Interleave,
    input [BIT_WIDTH-1:0] Compare,
    input [BIT_WIDTH-1:0] PWMMaxCount,
    input [BIT_WIDTH-1:0] TriangleStepSize,
    input [BIT_WIDTH-1:0] DeadTimeCount,
    output [(LevelCount*2)-1:0] S
    );
    
    logic [BIT_WIDTH-1:0] Level [0:15] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}; //convert to non-hardcoded if possible
    logic [BIT_WIDTH-1:0] InterleaveOffset;
    logic IntDoneFlag = 0;
    logic MultDoneFlag = 0;
    logic DivDoneFlag = 0;
    logic [BIT_WIDTH-1:0] divisor = PWMMaxCount;
    logic [BIT_WIDTH-1:0] divResult = 0;
    
    
    //Calculate InterleaveOffset based on particular interleave, number of interleaves, and PWMMaxCount
    //-- InterleaveOffset = (PWMMaxCount/InterleaveCount)*Interleave;
    
    //division block (PWMMaxCount/InterleaveCount)
    always@(*) begin
        if(~RstN) begin
            divisor <= PWMMaxCount;
            divResult <= 0;
            DivDoneFlag <= 0;
        end
        else begin
            if(divisor >= InterleaveCount) begin
                divisor <= divisor - InterleaveCount;
                divResult <= divResult+1;
                DivDoneFlag <= 0;
            end
            else begin
                DivDoneFlag <= 1;
            end
        end
    end
    
    //multiply block (Interleave*(PWMMaxCount/InterleaveCount))
     always_ff @ (posedge MClk) begin
        if(~RstN) begin
            IntDoneFlag <= 0;
            MultDoneFlag <= 0;
        end
        else if(DivDoneFlag & ~MultDoneFlag) begin //only should be entered once per reset
            InterleaveOffset <= Interleave*divResult; //MULT
            IntDoneFlag <= 0;
            MultDoneFlag <= 1;
        end
        else if (MultDoneFlag) begin //added clock after InterleaveOffset assigned
            IntDoneFlag <= 1;
        end
    end    
    
    generate 
        for (genvar i=0; i < LevelCount; i = i+1) begin
            LevelX #(.LevelCount(LevelCount), .BIT_WIDTH(BIT_WIDTH)) lX (.MClk(MClk), .RstN(RstN), .Level(Level[i]), .InterleaveOffset(InterleaveOffset), .IntDoneFlag(IntDoneFlag), .Compare(Compare), .PWMMaxCount(PWMMaxCount), .TriangleStepSize(TriangleStepSize), .DeadTimeCount(DeadTimeCount), .S(S[((i+1)*(2))-1:(i*2)]));
        end
    endgenerate

endmodule