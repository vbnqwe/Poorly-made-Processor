`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2023 02:24:58 PM
// Design Name: 
// Module Name: del_Test
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


module del_Test(

    );
    
    bit clk;
    wire [5:0] out_test;
    
    delay_test DUT ( .clk(clk), .out_test(out_test));
    
    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end
endmodule
