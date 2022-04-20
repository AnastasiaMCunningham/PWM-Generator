`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: https://github.com/AnastasiaMCunningham
// Engineer: Anastasia Cunningham
// 
// Create Date: 04/20/2022 03:52:43 PM
// Design Name: PWM Generator
// Module Name: Counter
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


module Counter
(
    input MClk,
    input Enable,
    input [15:0] MaxCount,
    output Done
);

    logic [15:0] count = 0;
    
    always_ff @ (posedge MClk) begin
        if (~Enable) begin
            count <= 0;
            Done <= 0;
        end
        else begin
            if (count >= MaxCount) begin
                Done <= 1;
            end
            else begin
                count <= count+1;
            end
        end
    end
    

endmodule

