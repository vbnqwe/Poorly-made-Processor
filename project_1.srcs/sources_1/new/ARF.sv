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
        input no_available,
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        output [31:0] r1_out [4],
        output [31:0] r2_out [4]
    );
    
    reg [31:0] core [32]; //data storage
    reg [6:0] tag [32];
    reg set_tag [32]; //if high, tag at index can be changed
    reg valid [32]; //if data in ARF entry is valid
    
    reg [6:0] intermediate_tag [32]; 
    
    int i;
    initial begin
        for(i = 0; i < 32; i++) begin
            set_tag[i] = 0;
            valid[i] = 0;
        end
    end
    
    genvar a;
    generate
        //logic here is redunant, remove at some point when you have time
        for(a = 0; a < 32; a = a + 1) begin
            always_comb begin
                if((((a == logical_dest[0]) & logical_dest_valid[0]) | ((a == logical_dest[1]) & logical_dest_valid[1]) | ((a == logical_dest[2]) & logical_dest_valid[2]) | ((a == logical_dest[3]) & logical_dest_valid[3])) & !no_available) begin
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
                if(set_tag[logical_dest[b]] & !no_available)
                    intermediate_tag[logical_dest[b]] = physical_dest[b];
                 else
                    intermediate_tag[logical_dest[b]] = tag[logical_dest[b]];
            end
        end
        
        //VERY IMPORTANT TO SEE: TO ENSURE THAT TAG CAN BE READ ON NEXT CYCLE THIS IS WRITTEN ON NEGEDGE
        //THIS MIGHT BE TOO SLOW SO LOOK FOR ALTERNATIVE SOLUTIONS
        //See github issue for potential solution
        for(b = 0; b < 32; b = b + 1) begin
            always @(posedge clk) begin
                if(!no_available) begin
                    tag[b] = intermediate_tag[b];
                end
            end
        end
    endgenerate
    
    
    
    
    
endmodule
