`timescale 1ns / 1ps


module Reservation_Station(
        input clk,
        input set,
        input [6:0] dest, r1, r2,
        input [31:0] r1_val, r2_val,
        input [31:0] instruction,
        input [1:0] valid_inputs,
        input [1:0] set_inputs,
        input [31:0] data_completed [4],
        input [6:0] completed [4],
        input [3:0] completed_valid,
        output reg [6:0] o_dest, o_r1, o_r2,
        output reg [31:0] o_r1_val, o_r2_val,
        output reg [31:0] o_instruction
    );  
    
    reg in_use;
    
    reg [31:0] r1_val, r2_val;
    reg [6:0] r1_physical_reg, r2_physical_reg;
    reg r1_valid, r2_valid;
    
    reg [6:0] destination;
    reg [31:0] full_instruction;
    
    //These values will be either the previously stored values or the newly updated values based off of set
    wire [31:0] r1_to_save, r2_to_save; 
    wire [6:0] r1_from, r2_from, dest_from;
    wire r1_from_vaild, r2_from_valid;
    
    
    //Wires that require muxes from inputs when set = 1
    wire [31:0] r1_data_new, r2_data_new;
    wire [6:0] r1_new, r2_new, dest_new;
    
    //create series of signals to check if completed will overwrite either old or new set of values
    wire if_overwrite_old_r1 [4];
    wire if_overwrite_old_r2 [4];
    reg [6:0] ow_r1;
    reg [6:0] ow_r2;
    genvar i;
    generate 
        for(i = 0; i < 4; i = i + 1) begin
            assign if_overwrite_old_r1[i] = (completed[i] == r1) & completed_valid[i];
            assign if_overwrite_old_r2[i] = (completed[i] == r2) & completed_valid[i];
            
            always_comb begin
                if(if_overwrite_old_r1[i]) begin
                    ow_r1 = completed[i];
                end
                if(if_overwrite_old_r2[i]) begin
                    ow_r2 = completed[i];
                end
            end
        end
    endgenerate
   
    
    //create logic that will overwrite sets of values if completed needs to overwrite
    always_comb begin
        
    end
    
    //create logic that will store whichever value on posedge clk
    always @(posedge clk) begin
        r1_val = set ? r1 : r1_to_save;
        r2_val = set ? r2 : r2_to_save;
    end
    
    //create logic that will select which data to output
    
    //create logic that will select when data is ready
    
    
endmodule
