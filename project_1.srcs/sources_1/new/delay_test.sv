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
        output [5:0] out_test
    );
    
    reg start;
    initial begin
        count = 0;
    end
    
    reg [5:0] count;
    always @(posedge clk) begin
        #10 start = 1;
    end
    
    always @(posedge start) begin
        count = count + 1;
        start = 0;
    end
    
    assign out_test = count;
endmodule
