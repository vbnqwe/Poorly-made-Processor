`timescale 1ns / 1ps


module Frontend_RAT(
        input [4:0] rd [4],
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input clk,
        input [6:0] next_physical [4],
        output reg [6:0] p_rd [4], 
        output reg [6:0] p_r1 [4], 
        output reg [6:0] p_r2 [4]
    );
    
    reg [7:0] logical_register_mapping [32]; //for mapping
    reg [31:0] valid; //if lr is valid
    
    always @(posedge clk) begin
        p_r1[0] = logical_register_mapping[r1[0]];
        p_r1[1] = logical_register_mapping[r1[1]];
        p_r1[2] = logical_register_mapping[r1[2]];
        p_r1[3] = logical_register_mapping[r1[3]];
        
        p_r2[0] = logical_register_mapping[r2[0]];
        p_r2[1] = logical_register_mapping[r2[1]];
        p_r2[2] = logical_register_mapping[r2[2]];
        p_r2[3] = logical_register_mapping[r2[3]];
        
        logical_register_mapping[rd[0]] = next_physical[0];
        logical_register_mapping[rd[1]] = next_physical[1];
        logical_register_mapping[rd[2]] = next_physical[2];
        logical_register_mapping[rd[3]] = next_physical[3];
        
        p_rd[0] = next_physical[0];
        p_rd[1] = next_physical[1];
        p_rd[2] = next_physical[2];
        p_rd[3] = next_physical[3];
    end
    
endmodule
