`timescale 1ns / 1ps

/*
Test bench that is used to test ROB, will contain lots of commented out code, will be messy.
Things to test:
    -Condition of when to write regs, such as when there are no physical registers available
*/

module ROB_tb(
        
    );
    
    reg no_available_hold;
    
    always @(posedge clk)
        no_available_hold = no_available;
    
    bit clk;
    wire no_available;
    bit [2:0] num_writes;
    
    bit expected;
    bit success;
    bit [7:0] newest, newest_prev;
    bit [7:0] oldest;
    bit [7:0] x;
    
    assign x = DUT.x;
    assign newest_prev = DUT.newest_prev;
    assign newest = DUT.newest;
    assign oldest = DUT.oldest_prev;
    
    initial begin
        #20;
    
        DUT.newest = 0;
        DUT.valid_entry[1] = 0;
        DUT.valid_entry[2] = 0;
        DUT.valid_entry[3] = 0;
        DUT.valid_entry[4] = 0;
        DUT.oldest = 10;
        num_writes = 4;
        expected = 0;
        #20;
        
        DUT.newest = 0;
        DUT.oldest = 2;
        num_writes = 4;
        DUT.valid_entry[1] = 0;
        DUT.valid_entry[2] = 1;
        DUT.valid_entry[3] = 1;
        DUT.valid_entry[4] = 1;
        expected = 1;
        #20;
        
        DUT.newest = 126;
        num_writes = 4;
        DUT.oldest = 10;
        DUT.valid_entry[127] = 0;
        DUT.valid_entry[0] = 0;
        DUT.valid_entry[1] = 0;
        DUT.valid_entry[2] = 0;
        expected = 0;
        #20;
        
        DUT.newest = 126;
        DUT.oldest = 127;
        num_writes = 2;
        DUT.valid_entry[127] = 1;
        DUT.valid_entry[0] = 1;
        DUT.valid_entry[1] = 1;
        DUT.valid_entry[2] = 1;
        expected = 1;
        #20;
        
        DUT.newest = 126;
        DUT.oldest = 0;
        num_writes = 4;
        DUT.valid_entry[127] = 0;
        DUT.valid_entry[0] = 1;
        DUT.valid_entry[1] = 1;
        DUT.valid_entry[2] = 1;
        expected = 1;            
        #20;
        $stop;
        
    end
    
    
    ROB DUT(.clk(clk), .num_writes(num_writes), .no_available(no_available));
    
    always begin
        clk = 1; 
        #10;
        clk = 0;
        #10;
    end
endmodule
