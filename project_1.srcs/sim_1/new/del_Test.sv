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
    bit a;
    wire [2:0] out_test;
    
    delay_test DUT ( .clk(clk), .a(a), .out(out_test));
    
    initial begin
        a = 1;
        
        #30;
        a =0;
        #2;
        a = 1;
        
        #20;
        $stop;
    end
    
    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end
endmodule
