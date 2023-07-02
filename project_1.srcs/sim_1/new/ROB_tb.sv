`timescale 1ns / 1ps

/*
Test bench that is used to test ROB, will contain lots of commented out code, will be messy.
Things to test:
    -Condition of when to write regs, such as when there are no physical registers available
*/

module ROB_tb(
        
    );
    
    bit clk;
    wire no_available;
    bit [2:0] num_writes;
    
    bit expected;
    bit success;
    bit [7:0] newest;
    bit [7:0] oldest;
    bit [7:0] x;
    
    assign x = DUT.x;
    assign newest = DUT.newest_prev;
    assign oldest = DUT.oldest_prev;
    
    initial begin
        DUT.newest = 0;
        DUT.oldest = 10;
        num_writes = 4;
        expected = 0;
        if(expected == no_available)
            $display("Success 1");
        else
            $display("Failure 1");
        
        #20;
        
        DUT.newest = 0;
        DUT.oldest = 2;
        num_writes = 4;
        expected = 1;
        if(expected == no_available)
            $display("Success 2");
        else
            $display("Failure 2");
        
        #20;
        
        DUT.newest = 126;
        num_writes = 4;
        DUT.oldest = 10;
        expected = 0;
        if(expected == no_available)
            $display("Success 3");
        else
            $display("Failure 3");
        
        #20;
        
        DUT.newest = 126;
        DUT.oldest = 127;
        num_writes = 2;
        expected = 1;
        if(expected == no_available)
            $display("Success 4");
        else
            $display("Failure 4");
        
        #20;
        
        DUT.newest = 126;
        DUT.oldest = 0;
        num_writes = 4;
        expected = 1;
        if(expected == no_available)
            $display("Success 5");
        else
            $display("Failure 5");
            
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
