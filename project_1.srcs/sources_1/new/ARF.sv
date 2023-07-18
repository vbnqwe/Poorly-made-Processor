`timescale 1ns / 1ps
/*
Destcription:
    -Reads r1 and r2 assynchronously
    -On posedge of clk, will commit/write to register file
    -On posedge of clk, will set the destination register of the new instructions in rename stage to have an
        editable tag
    -Tag of destination register will be assynchronously written
    
    
Inputs:
    -rX: read out register at address rX
    -dest/dest_valid: dest is logical register destination, dest_valid specifies if tag will need to be set
    -clk: if you don't know this then there is an issue
    -physical_dest: physical destination register of an instruction assigned in ROB, equal to tag
    -no_available: if high, cannot write tags
    
Outputs:
    -rX_out: output of read register

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
        input [31:0] committed [8],
        input [4:0] committed_dest [8],
        input [7:0] committed_valid,
        output [31:0] r1_out [4],
        output [31:0] r2_out [4],
        output [3:0] r1_ready, r2_ready,
        output [6:0] r1_tag [4],
        output [6:0] r2_tag [4]
    );
    
    reg [31:0] core [32]; //data storage
    reg [6:0] tag [32];
    wire [6:0] tag_wire [32];
    reg set_tag [32]; //if high, tag at index can be changed
    reg set_tag_prev [32];
    reg valid [32]; //if data in ARF entry is valid
    
    assign tag_wire = tag;
        
    int i;
    initial begin
        for(i = 0; i < 32; i++) begin
            set_tag[i] = 0;
            valid[i] = 0;
        end
    end
    
    genvar a;
    generate
        for(a = 0; a < 4; a = a + 1) begin
            assign r1_tag[a] = core[r1[a]];
            assign r2_tag[a] = core[r2[a]];
            assign r1_ready[a] = valid[r1[a]];
            assign r2_ready[a] = valid[r2[a]];
            assign r1_tag[a] = tag[r1[a]];
            assign r2_tag[a] = tag[r2[a]];
        end
    
        //logic here is redunant, remove at some point when you have time
        for(a = 0; a < 32; a = a + 1) begin
            always_comb begin
                if((((a == logical_dest[0]) & logical_dest_valid[0]) | ((a == logical_dest[1]) & logical_dest_valid[1]) | ((a == logical_dest[2]) & logical_dest_valid[2]) | ((a == logical_dest[3]) & logical_dest_valid[3])) & !no_available) begin
                    set_tag[a] = 1;
                end else 
                    set_tag[a] = 0;
            end
            
            always @(posedge clk) begin
                set_tag_prev[a] = set_tag[a];
                set_tag[a] = 0;
            end
        end
         
        
        //write r1 and r2 and all corresponding values
        for(a = 0; a < 4; a = a + 1) begin
            assign r1_out[a] = core[r1[a]];
            assign r2_out[a] = core[r2[a]];
            assign r1_ready[a] = valid[r1[a]];
            assign r2_ready[a] = valid[r2[a]];
            assign r1_tag[a] = tag[r1[a]];
            assign r2_tag[a] = tag[r2[a]];
        end
    endgenerate
    
    wire highest_priority [4]; //ith value corresponds to if an instruction's dest tag needs to be updated
    //eg: say instruction 0 is r1 = r2 + r3, instruction 1 is r1 = r3 + r4
    //if they run in the same cycle, tag for r1 needs to be tag from instruction 2, not instruction 1
    //therefore, highest_priority[0] = 0, highest_priority[1] = 1
    
    
    assign highest_priority[0] = !(((logical_dest[0] == logical_dest[1]) & logical_dest_valid[1]) | ((logical_dest[0] == logical_dest[2]) & logical_dest_valid[2]) | ((logical_dest[0] == logical_dest[3]) & logical_dest_valid[3]));
    assign highest_priority[1] = !(((logical_dest[1] == logical_dest[2]) & logical_dest_valid[2]) | ((logical_dest[1] == logical_dest[3]) & logical_dest_valid[3]));
    assign highest_priority[2] = !((logical_dest[2] == logical_dest[3]) & logical_dest_valid[3]);
    assign highest_priority[3] = 1;
    
    
    wire [31:0] core_not [8]; 
    wire valid_not [8];
    genvar d;
    for(d = 0; d < 8; d++) begin
       assign core_not[d] = core[committed_dest[d]];
       assign valid_not[d] = valid[committed_dest[d]];
    end
    
    always @(posedge clk) begin
        //Commit occurs first
        core[committed_dest[0]] = committed_valid[0] ? committed[0] : core_not[0];
        core[committed_dest[1]] = committed_valid[1] ? committed[1] : core_not[1];
        core[committed_dest[2]] = committed_valid[2] ? committed[2] : core_not[2];
        core[committed_dest[3]] = committed_valid[3] ? committed[3] : core_not[3];
        core[committed_dest[4]] = committed_valid[4] ? committed[4] : core_not[4];
        core[committed_dest[5]] = committed_valid[5] ? committed[5] : core_not[5];
        core[committed_dest[6]] = committed_valid[6] ? committed[6] : core_not[6];
        core[committed_dest[7]] = committed_valid[7] ? committed[7] : core_not[7];    
        valid[committed_dest[0]] = committed_valid[0] ? 1 : valid_not[0];  
        valid[committed_dest[1]] = committed_valid[1] ? 1 : valid_not[1];  
        valid[committed_dest[2]] = committed_valid[2] ? 1 : valid_not[2];  
        valid[committed_dest[3]] = committed_valid[3] ? 1 : valid_not[3];  
        valid[committed_dest[4]] = committed_valid[4] ? 1 : valid_not[4];  
        valid[committed_dest[5]] = committed_valid[5] ? 1 : valid_not[5];  
        valid[committed_dest[6]] = committed_valid[6] ? 1 : valid_not[6];  
        valid[committed_dest[7]] = committed_valid[7] ? 1 : valid_not[7];   
        
        //Allocation occurs second, as to overwrite commits if necessary
        tag[logical_dest[0]] = (logical_dest_valid[0] & !no_available & set_tag_prev[logical_dest[0]] & highest_priority[0]) ? physical_dest[0] : tag_wire[logical_dest[0]];
        tag[logical_dest[1]] = (logical_dest_valid[1] & !no_available & set_tag_prev[logical_dest[1]] & highest_priority[1]) ? physical_dest[1] : tag_wire[logical_dest[1]];
        tag[logical_dest[2]] = (logical_dest_valid[2] & !no_available & set_tag_prev[logical_dest[2]] & highest_priority[2]) ? physical_dest[2] : tag_wire[logical_dest[2]];
        tag[logical_dest[3]] = (logical_dest_valid[3] & !no_available & set_tag_prev[logical_dest[3]] & highest_priority[3]) ? physical_dest[3] : tag_wire[logical_dest[3]];
        valid[logical_dest[0]] = (logical_dest_valid[0] & !no_available & set_tag_prev[logical_dest[0]] & highest_priority[0]) ? 0 : valid[logical_dest[0]];
        valid[logical_dest[1]] = (logical_dest_valid[1] & !no_available & set_tag_prev[logical_dest[1]] & highest_priority[1]) ? 0 : valid[logical_dest[1]];
        valid[logical_dest[2]] = (logical_dest_valid[2] & !no_available & set_tag_prev[logical_dest[2]] & highest_priority[2]) ? 0 : valid[logical_dest[2]];
        valid[logical_dest[3]] = (logical_dest_valid[3] & !no_available & set_tag_prev[logical_dest[3]] & highest_priority[3]) ? 0 : valid[logical_dest[3]];
    end
    
    
    
    
    
    
endmodule
