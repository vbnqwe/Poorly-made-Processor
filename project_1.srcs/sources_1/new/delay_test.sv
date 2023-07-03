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
        input a
        , output [2:0] out
    );
    
    reg [2:0] x;
    
    assign out = x;
    
    
    assign x[0] = a;
    genvar d;
    generate
        for(d = 1; d < 3; d = d + 1) begin
            always_comb begin
                x[d] = x[d-1] & a;
            end
        end
    endgenerate
    
endmodule
