`timescale 1ns / 1ps

/*
Test bench that is used to test ROB, will contain lots of commented out code, will be messy.
Things to test:
    -Condition of when to write regs, such as when there are no physical registers available
*/

module ROB_tb(
        
    );
    
    bit [2:0] num_writes;
    bit clk;
    bit if_reg [4];
    wire no_available;
    wire [31:0] committed [8];
    wire [5:0] committed_dest [8];
    wire [3:0] num_commits;
    wire ready [8];
    wire [2:0] test;
    
    assign test = {DUT.valid_entry[21], DUT.completed_entry[21], DUT.ready_to_commit[0]};
    
    assign ready = DUT.ready_to_commit;
    
    initial begin
        #1;
        DUT.oldest_prev = 20;
        DUT.valid_entry[20] = 1;
        DUT.valid_entry[21] = 1;
        DUT.oldest = 20;
        DUT.completed_entry[20] = 1;
        DUT.completed_entry[21] = 1;
        DUT.data[20] = 20;
        DUT.data[21] = 21;
        #40;
        $display(DUT.valid_entry[20]);
        $display(DUT.completed_entry[20]);
        $stop;
        
    end
    
    
    ROB DUT(.clk(clk), .num_writes(num_writes), .no_available(no_available), .committed, .committed_dest, .num_commits);
    
    always begin
        clk = 0; 
        #10;
        clk = 1;
        #10;
    end
endmodule
