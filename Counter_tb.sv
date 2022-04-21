`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 08:38:47 AM
// Design Name: 
// Module Name: Counter_tb
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


module Counter_tb;

    reg MClk, Enable;
    reg [15:0] MaxCount;
    wire Done;
    wire [15:0] Count;
    
    Counter uut(MClk, Enable, MaxCount, Done, Count);
    
    always begin
        MClk = 1'b1;
        #20;
        MClk = 1'b0;
        #20;
    end
    
    always@(posedge MClk) begin
        Enable = 0;
        MaxCount = 500;
        
        #100;
        
        Enable = 1;
        
        #1000000
    
    
    $stop;
    end
    
endmodule
