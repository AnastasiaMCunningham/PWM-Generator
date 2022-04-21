`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 08:38:47 AM
// Design Name: 
// Module Name: DeadTimer_tb
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


module DeadTimer_tb;
    
    parameter BIT_WIDTH = 16;
    logic MClk, RstN;
    logic [BIT_WIDTH-1:0] DeadTimeCount;
    logic [1:0] SPDT;
    logic [1:0] S;
    
    DeadTimer #(BIT_WIDTH) uut(MClk, RstN, DeadTimeCount, SPDT, S);
    
    always begin
        MClk = 1'b1;
        #20;
        MClk = 1'b0;
        #20;
    end
    
    always@(posedge MClk) begin
        RstN = 1'b0;
        DeadTimeCount = 5;
        SPDT = {1'b0, 1'b0};
        
        #100;
        
        RstN = 1'b1;
        
        #100;
        
        SPDT = {1'b1, 1'b0};
        
        #1000;
        
        SPDT = {1'b0, 1'b1};
        
        #1000;
        
        RstN = 1'b0;
        
        
        #1000000
    
    
    $stop;
    end
    

endmodule
