`timescale 1ns / 1ps


module Reservation_Station(
        input clk,
        input set,
        input [6:0] dest, r1, r2,
        input [31:0] r1_val, r2_val,
        input [31:0] instruction,
        input [1:0] valid_inputs,
        input [1:0] set_inputs,
        output reg [6:0] o_dest, o_r1, o_r2,
        output reg [31:0] o_r1_val, o_r2_val,
        output reg [31:0] o_instruction
    );  
    
    reg [6:0] s_dest, s_r1, s_r2;
    reg [31:0] s_r1_val, s_r2_val, s_instruction;
    reg [1:0] s_valid_inputs;
        
    
    
    always_comb begin
        if(set) begin
            s_dest = dest;
            s_r1 = r1;
            s_r2 = r2;
            s_r1_val = r1_val;
            s_r2_val = r2_val;
            s_instruction = instruction;
            s_valid_inputs = valid_inputs;
        end
        
        
        if(s_valid_inputs == 2'b11) begin
            o_dest = s_dest;
            o_r1 = s_r1;
            o_r2 = s_r2;
            o_r1_val = s_r1_val;
            o_r2_val = s_r2_val;
            o_instruction = s_instruction;
        end 
        
        
        //CLOCK THIS?
        if (set_inputs == 2'b01) begin
            s_r1_val = r1_val;
            s_valid_inputs[0] = 1;
        end else if (set_inputs == 2'b10) begin
            s_r2_val = r2_val;
            s_valid_inputs[1] = 1;
        end else if (set_inputs == 2'b11) begin
            s_r1_val = r1_val;
            s_r2_val = r2_val;
            s_valid_inputs = 2'b11;
        end
        
    end
endmodule
