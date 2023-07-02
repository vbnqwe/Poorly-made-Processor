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
        input clk
        , output [2:0] out
    );
    
    assign out = d;
    
    reg [2:0] d;
    reg [2:0] d_prev;
  
    
    always @(posedge clk) begin
        d_prev = d;
    end
    
    wire con = |d;
    wire [2:0] d1 = d_prev + 1;
    wire [2:0] d2 = d_prev;
    
    assign d = con ? d1 : d2;
    
endmodule
