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


module Counter #(

    parameter BIT_WIDTH = 16
)
(
    input MClk,
    input Enable,
    input [BIT_WIDTH-1:0] MaxCount,
    output Done,
    output [BIT_WIDTH-1:0] Count
);

    logic [BIT_WIDTH-1:0] CountReg = 0;
    logic DoneReg = 0;
    
    assign Done = DoneReg;
    assign Count = CountReg;
    
    always_ff @ (posedge MClk) begin
        if (~Enable) begin
            CountReg <= 0;
            DoneReg <= 0;
        end
        else begin
            if (CountReg >= MaxCount-1) begin
                DoneReg <= 1;
            end
            else begin
                CountReg <= CountReg+1;
            end
        end
    end
    

endmodule

