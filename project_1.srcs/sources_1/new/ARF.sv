`timescale 1ns / 1ps
/*
Destcription:
    -Reads r1 and r2 assynchronously
    -On posedge of clk, will commit/write to register file
    -On posedge of clk, will set the destination register of the new instructions in rename stage to have an
        editable tag
    -Tag of destination register will be assynchronously written
    
    
Inputs:
    -rX/rX_valid: if rX_valid[i] is high, then will read out rX[i]
    -dest/dest_valid: same as rX/rX_valid, but with additional logic for connecting to ROB

Outputs:
*/

module ARF(
        input clk,
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input [3:0] r1_valid,
        input [3:0] r2_valid,
        input [4:0] dest [4],
        input [3:0] dest_valid,
        output [4:0] r1_out [4],
        output [4:0] r2_out [4]  
    );
    
    reg [31:0] core [32];
    reg [4:0] rob_tag [32];
    reg rob_tag_valid [32];
    reg just_allocated [32]; //In the case a commit takes too long
    reg [4:0] dest_to_write [4];
    
    
    
    //assynchronous read
    genvar a;
    generate
        for(a = 0; a < 4; a = a + 1) begin
            assign r1_out[a] = core[r1[a]];
            assign r2_out[a] = core[r2[a]];
            assign dest[a] = rob_tag[a];
        end 
    endgenerate
    
    genvar b;
    generate 
        for(b = 0; b < 4; b = b + 1) begin
            always @(posedge clk) begin
                dest_to_write[b] = dest[4];
                if(dest_valid[b]) begin
                    
                end
            end
        end
    endgenerate
    
endmodule
