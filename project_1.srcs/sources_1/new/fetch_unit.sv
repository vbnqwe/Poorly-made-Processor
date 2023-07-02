`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2023 07:37:12 PM
// Design Name: 
// Module Name: fetch_unit
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


module fetch_unit(
        input wire [31:0] undecoded_instr,
        output wire [31:0] op1, op2, op3 
    );
    
    reg [4:0] logical_registers [32];
    reg [6:0] mappings [128];
endmodule
