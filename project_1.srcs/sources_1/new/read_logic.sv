`timescale 1ns / 1ps


/*
This module will be used to calculate the expected location of where to a register from in the ROB. It is just a module to
hold a bunch of combinational logic, to make the rest of the code easier to read.
If rX_rewritten is high, that means that this register's location has been changed as a prior instruction from this cycle is 
updating the value, meaning that rather than reading from the ARF/ARF tag in ROB, it will need to read from the r1_rob_val 
tag instead as this will be the correct destination.
*/
module read_logic(
        input [4:0] dest [4],
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input [3:0] dest_valid,
        input [6:0] newest,
        output reg r1_rob_val [4],
        output reg r2_rob_val [4],
        output reg [3:0] r1_rewritten,
        output reg [3:0] r2_rewritten
    );
    
    reg [2:0] num_writes;
    assign num_writes = dest_valid[0] + dest_valid[1] + dest_valid[2] + dest_valid[3];
    
    always_comb begin
        //no prior instructions to rewrite to
        r1_rob_val[0] = 0;
        r2_rob_val[0] = 0;
        r1_rewritten[0] = 0;
        r2_rewritten[0] = 0;
        
        //check if dest[0] is equal to rX[1], if it is, calculate new tag
        if((dest[0] == r1[1]) & dest_valid[0]) begin
            r1_rob_val[1] = (newest + 1) % 128;
            r1_rewritten[1] = 1;
        end else begin
            r1_rewritten[1] = 0;
            r1_rob_val[1] = 0;
        end
        if((dest[0] == r2[1]) & dest_valid[0]) begin
            r2_rob_val[1] = (newest + 1) % 128;
            r2_rewritten[1] = 1;
        end else begin
            r2_rewritten[1] = 0;
            r2_rob_val[1] = 0;
        end
        
        //check if dest[1] is equal to rX[2], if it is, check if 1 or 2 writes have happened (dest_valid[0 and 1])
        //else check if dest[0] is equal to rX[2], if it is, check if dest_valid[0] is true
        //else rewritten is low
        if((dest[1] == r1[2]) & dest_valid[1]) begin
            r1_rob_val[2] = (newest + dest_valid[0] + dest_valid[1]) % 128;
            r1_rewritten[2] = 1;
        end else if ((dest[0] == r1[2]) & dest_valid[0]) begin
            r1_rob_val[2] = (newest + 1) % 128;
            r1_rewritten[2] = 1;
        end else begin
            r1_rob_val[2] = 0;
            r1_rewritten[2] = 0;
        end
        if((dest[1] == r2[2]) & dest_valid[1]) begin
            r2_rob_val[2] = (newest + dest_valid[0] + dest_valid[1]) % 128;
            r2_rewritten[2] = 1;
        end else if ((dest[0] == r2[2]) & dest_valid[0]) begin
            r2_rob_val[2] = (newest + 1) % 128;
            r2_rewritten[2] = 1;
        end else begin
            r2_rob_val[2] = 0;
            r2_rewritten[2] = 0;
        end
        
        //check if dest[2] is equal to rX[3]
        //else check if dest[1] is equal to rX[3]
        //else check if dest[0] is equal to rX[3]
        //else rewritten is low
        if((dest[2] == r1[3]) & dest_valid[2]) begin
            r1_rob_val[3] = (newest + dest_valid[2] + dest_valid[1] + dest_valid[0]) % 128;
            r1_rewritten[3] = 1;
        end else if ((dest[1] == r1[3]) & dest_valid[1]) begin
            r1_rob_val[3] = (newest + dest_valid[1] + dest_valid[0]) % 128;
            r1_rewritten[3] = 1;
        end else if ((dest[0] == r1[3]) & dest_valid[0]) begin
            r1_rob_val[3] = (newest + dest_valid[0]) % 128;
            r1_rewritten[3] = 1;
        end else begin
            r1_rob_val[3] = 0;
            r1_rewritten[3] = 0;
        end
        if((dest[2] == r2[3]) & dest_valid[2]) begin
            r2_rob_val[3] = (newest + dest_valid[2] + dest_valid[1] + dest_valid[0]) % 128;
            r2_rewritten[3] = 1;
        end else if ((dest[1] == r2[3]) & dest_valid[1]) begin
            r2_rob_val[3] = (newest + dest_valid[1] + dest_valid[0]) % 128;
            r2_rewritten[3] = 1;
        end else if ((dest[0] == r2[3]) & dest_valid[0]) begin
            r2_rob_val[3] = (newest + dest_valid[0]) % 128;
            r2_rewritten[3] = 1;
        end else begin
            r2_rob_val[3] = 0;
            r2_rewritten[3] = 0;
        end
    end
    
    
endmodule
