`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: https://github.com/AnastasiaMCunningham
// Engineer: Anastasia Cunningham
// 
// Create Date: 04/20/2022 03:52:43 PM
// Design Name: PWM Generator
// Module Name: DeadTimer
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


module DeadTimer 
(
    input MClk,
    input RstN,
    input [15:0] DeadTimeCount,
    input [1:0] SPDT,
    output [1:0] S
    );

    logic [1:0] SLast; //previous clock's SPDT
    logic DTDn = 0;
    logic DTEn = 0;
    
    Counter dtCntr(.MClk(MClk), .Enable(DTEn), .MaxCount(DeadTimeCount), .Done(DTDn));

    always_ff @ (posedge MClk) begin
        if (~RstN) begin
            SLast <= SPDT;
            DTEn <= 0;
            DTDn <= 0;
        end
        else begin           
            if (SLast != SPDT & DeadTimeCount > 0) begin //if DeadTimeCount = 0, this logic must be skipped
                if(DTDn) begin //check for Dead Time Counter done signal (should always fail for the first pass)
                    DTEn <= 0;
                    S <= SPDT;
                end
                else begin
                    S <= {0, 0}; //hold both PWM signals low
                    DTEn <= 1; //enable Dead Time Counter
                end
            end
            else begin
                S <= SPDT;
                SLast <= SPDT;
            end
        end    
    end

endmodule

