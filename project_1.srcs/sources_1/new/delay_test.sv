`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2023 02:22:49 PM
// Design Name: 
// Module Name: delay_test
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


module delay_test(
        input clk,
        input a,
        input b,
        output c
    );
    
    reg d;
    
  
    
    always @(posedge clk) begin
        d = a & b;
    end
    
    assign c = d;
    
endmodule
