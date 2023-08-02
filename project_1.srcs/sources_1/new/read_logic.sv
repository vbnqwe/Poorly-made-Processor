`timescale 1ns / 1ps


/*
This module will be used to calculate the location of where to access each source register. Making it into a seperate module
may increase logic cell cost, but it does make the code nicer so \_(.`/ )_/
*/

module read_logic_module(
        input clk,
        input [4:0] dest_in [4],
        input [4:0] r1_in [4],
        input [4:0] r2_in [4],
        input [3:0] dest_valid_in,
        input [6:0] newest,
        output reg [6:0] r1_read_from [4],
        output reg [6:0] r2_read_from [4],
        output reg [3:0] r1_ARF_or_ROB,
        output reg [3:0] r2_ARF_or_ROB
    );
    
    reg [4:0] dest [4];
    reg [4:0] r1 [4];
    reg [4:0] r2 [4];
    reg [3:0] dest_valid;
    
    
    always @(posedge clk) begin
        dest <= dest_in;
        r1 <= r1_in;
        r2 <= r2_in;
        dest_valid <= dest_valid_in;
    end
    
    
    /* //store last state of tags/valid bits
    always @(posedge clk) begin
        tag <= DUT.reg_file.tag;
        valid <= valid_bits;
    end*/
    
    
    always_comb begin
        
        //if reading from same address as writing to you need to read from this address
        r1_read_from[0] = r1[0];
        r1_ARF_or_ROB[0] = 1;
    
        r2_read_from[0] = r2[0];
        r2_ARF_or_ROB[0] = 1;
    
    
        if((dest[0] == r1[1]) & dest_valid[0]) begin
            r1_read_from[1] = (newest + 1) % 128;
            r1_ARF_or_ROB[1] = 0;
        end else begin
            r1_read_from[1] = r1[1];
            r1_ARF_or_ROB[1] = 1;
        end
        
        if((dest[0] == r2[1]) & dest_valid[0]) begin
            r2_read_from[1] = (newest + 1) % 128;
            r2_ARF_or_ROB[1] = 0;
        end else begin
            r2_read_from[1] = r2[1];
            r2_ARF_or_ROB[1] = 1;
        end 
        
        
        
        if((dest[1] == r1[2]) & dest_valid[1]) begin
            r1_read_from[2] = (newest + dest_valid[0] + dest_valid[1]) % 128;
            r1_ARF_or_ROB[2] = 0;
        end else if ((dest[0] == r1[2]) & dest_valid[0])begin
            r1_read_from[2] = (newest + dest_valid[0]) % 128;
            r1_ARF_or_ROB[2] = 0;
        end else begin
            r1_read_from[2] = r1[2];
            r1_ARF_or_ROB[2] = 1;
        end 
        
        if((dest[1] == r2[2]) & dest_valid[1]) begin
            r2_read_from[2] = (newest + dest_valid[0] + dest_valid[1]) % 128;
            r2_ARF_or_ROB[2] = 0;
        end else if ((dest[0] == r2[2]) & dest_valid[0])begin
            r2_read_from[2] = (newest + dest_valid[0]) % 128;
            r2_ARF_or_ROB[2] = 0;
        end else begin
            r2_read_from[2] = r2[2];
            r2_ARF_or_ROB[2] = 1;
        end 
        
        
        
        if((dest[2] == r1[3]) & dest_valid[2]) begin
            r1_read_from[3] = (newest + dest_valid[0] + dest_valid[1] + dest_valid[2]) % 128;
            r1_ARF_or_ROB[3] = 0;
        end else if ((dest[1] == r1[3]) & dest_valid[1]) begin
            r1_read_from[3] = (newest + dest_valid[0] + dest_valid[1]) % 128;
            r1_ARF_or_ROB[3] = 0;
        end else if ((dest[0] == r1[3]) & dest_valid[0]) begin
            r1_read_from[3] = (newest + dest_valid[0]) % 128;
            r1_ARF_or_ROB[3] = 0;
        end else begin
            r1_read_from[3] = r1[3];
            r1_ARF_or_ROB[3] = 1;
        end 
        
        if((dest[2] == r2[3]) & dest_valid[2]) begin
            r2_read_from[3] = (newest + dest_valid[0] + dest_valid[1] + dest_valid[2]) % 128;
            r2_ARF_or_ROB[3] = 0;
        end else if ((dest[1] == r2[3]) & dest_valid[1]) begin
            r2_read_from[3] = (newest + dest_valid[0] + dest_valid[1]) % 128;
            r2_ARF_or_ROB[3] = 0;
        end else if ((dest[0] == r2[3]) & dest_valid[0]) begin
            r2_read_from[3] = (newest + dest_valid[0]) % 128;
            r2_ARF_or_ROB[3] = 0;
        end else begin
            r2_read_from[3] = r2[3];
            r2_ARF_or_ROB[3] = 1;
        end 
    end
    
    
endmodule
