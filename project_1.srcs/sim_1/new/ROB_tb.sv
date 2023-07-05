`timescale 1ns / 1ps

/*
Test bench that is used to test ROB, will contain lots of commented out code, will be messy.
Things to test:
    -Condition of when to write regs, such as when there are no physical registers available
*/

module ROB_tb(
        
    );
    
    bit clk;
    bit [2:0] num_writes;
    bit if_reg [4];
    bit [4:0] dest [4];
    wire no_available;
    wire [31:0] committed [8];
    wire [4:0] committed_dest [8];
    wire [3:0] num_commits;
    
    wire [31:0] data [128];
    wire valid_entry [128];
    wire completed_entry [128];
    wire [4:0] dest_reg [128];
    
    wire [7:0] newest, newest_prev, oldest, oldest_prev;
    
    assign newest = DUT.newest;
    assign newest_prev = DUT.newest_prev;
    assign oldest = DUT.oldest;
    assign oldest_prev = DUT.oldest_prev;
    
    assign data = DUT.data;
    assign valid_entry = DUT.valid_entry;
    assign completed_entry = DUT.completed_entry;
    assign dest_reg = DUT.dest_reg;
    
    
    initial begin
        num_writes = 3'd2;
        dest[0] = 5'd2;
        dest[1] = 5'd3;
        #20;
        num_writes = 3'd1;
        dest[0] = 5'd4;
        #20;
        num_writes = 3'd0;
        dest[0] = 5'd20;
        DUT.completed_entry[2] = 1;
        #20;
        DUT.completed_entry[1] = 1;
        num_writes = 3'd4;
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest[2] = 5'd3;
        dest[3] = 5'd4;
        #20;
        $stop;
        
    end
    
    
    ROB DUT(.clk, .num_writes, .if_reg, .dest, .no_available, .committed, .committed_dest, .num_commits);
    
    always begin
        clk = 0; 
        #10;
        clk = 1;
        #10;
    end
endmodule
