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
    -dest/dest_valid: same as rX/rX_valid, but with additional logic for connecting to ROB, destination of operation

Outputs:
*/

module ARF(
        input [4:0] logical_dest [4],
        input [3:0] logical_dest_valid,
        input clk,
        input [6:0] physical_dest [4],
        input no_available
    );
    
    reg [31:0] core [32]; //data storage
    reg [6:0] tag [32];
    reg set_tag [32]; //if high, tag at index can be changed
    reg valid [32]; //if data in ARF entry is valid
    
    
    genvar a;
    generate
        for(a = 0; a < 32; a = a + 1) begin
            always @(posedge clk) begin
                if(((a == logical_dest[0]) & logical_dest_valid[0]) | ((a == logical_dest[1]) & logical_dest_valid[1]) | ((a == logical_dest[2]) & logical_dest_valid[2]) | ((a == logical_dest[3]) & logical_dest_valid[3])) begin
                    set_tag[a] = 1;
                end else 
                    set_tag[a] = 0;
            end
        end
    endgenerate
    
    genvar b;
    generate
        for(b = 0; b < 4; b = b + 1) begin
            always_comb begin
                if(set_tag[logical_dest[a]] & !no_available)
                    tag[logical_dest[a]] = physical_dest[a];
            end
        end
    endgenerate
    
    
    
    
endmodule
