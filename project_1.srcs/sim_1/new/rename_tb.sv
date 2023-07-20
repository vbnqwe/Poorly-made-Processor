`timescale 1ns / 1ps


module rename_tb(

    );
    
    bit clk;
    bit clk2;
    bit x;
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
    
    wire [6:0] tag [32];
    wire valid_arf [32];
    wire valid_rob [128];
    wire completed [128];
    wire [4:0] dest_rob [128];
    wire [4:0] committed_dest [8];
    
    wire [6:0] allocated [4];
    wire [4:0] prev_dest [4];
    wire [6:0] tag_to_write [4];
    
    assign tag = DUT.reg_file.tag;
    assign valid_arf = DUT.reg_file.valid;
    assign valid_rob = DUT.buffer.valid_entry;
    assign completed = DUT.buffer.completed_entry;
    assign dest_rob = DUT.buffer.dest_reg;
    assign committed_dest = DUT.reg_file.committed_dest;
    assign allocated = DUT.allocated;
    assign prev_dest = DUT.reg_file.prev_dest;
    assign tag_to_write = DUT.reg_file.tag_to_write;
        
    rename_top DUT(
        .clk(clk), 
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
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest[2] = 5'd3;
        dest[3] = 5'd4;
        stall_external = 0;
        x = 1;
        dest_valid = 4'b1111;
        #20;
        stall_external = 1;
        dest[0] = 5'd5;
        dest[2] = 5'd6;
        num_writes = 2;
        dest_valid = 4'b0101;
        x = 0;
        #20;
        x = 1;
        stall_external = 0;
        dest[1] = 5'd7;
        dest[3] = 5'd8;
        dest_valid = 4'b1010;
        #20;
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest_valid = 4'b0011;
        #20;
        num_writes = 0;
        dest_valid = 4'b0;
        #20;
        $stop;
    end
    
    assign clk2 = clk & x;
    
    always begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end
endmodule
