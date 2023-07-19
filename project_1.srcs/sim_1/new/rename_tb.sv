`timescale 1ns / 1ps


module rename_tb(

    );
    
    bit clk;
    bit [2:0] num_writes;
    bit [4:0] dest[4];
    bit [4:0] r1 [4];
    bit [4:0] r2 [4];
    bit [3:0] dest_valid;
    bit stall_external;
    
    wire [6:0] physical_dest [4];
    wire [3:0] physical_dest_valid;
    wire [3:0] r1_ready, r2_ready;
    wire [6:0] r1_source [4];
    wire [6:0] r2_source [4];
    wire stall_internal;
    
    
    rename_top DUT(
        .clk, 
        .num_writes, 
        .dest, 
        .r1, 
        .r2, 
        .dest_valid, 
        .stall_external, 
        .physical_dest, 
        .physical_dest_valid, 
        .r1_ready,
        .r2_ready,
        .r1_source,
        .r2_source,
        .stall_internal
    );
    
    initial begin
        num_writes = 4;
        
    end
    
    always begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end
endmodule
