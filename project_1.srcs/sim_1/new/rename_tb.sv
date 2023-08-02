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
    wire [3:0] r1_ready_out, r2_ready_out;
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
    
    wire [3:0] r1_ARF_or_ROB, r2_ARF_or_ROB;
    assign r1_ARF_or_ROB = DUT.RLM.r1_ARF_or_ROB;
    assign r2_ARF_or_ROB = DUT.RLM.r2_ARF_or_ROB;
    wire [6:0] r1_pot_tag [4];
    wire [6:0] r2_pot_tag [4];
    assign r1_pot_tag = DUT.RLM.r1_read_from;
    assign r2_pot_tag = DUT.RLM.r2_read_from;
    
    wire [3:0] r1_ready_t, r2_ready_t;
    assign r1_ready_t = DUT.r1_ready;
    assign r2_ready_t = DUT.r2_ready;
    

    
    wire [3:0] r1_ready;
    wire [3:0] r2_ready;
    assign r1_ready = DUT.RLM.r1_ARF_or_ROB;
    assign r2_ready = DUT.RLM.r2_ARF_or_ROB;
        
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
        .r1_ready_out,
        .r2_ready_out,
        .r1_source,
        .r2_source,
        .stall_internal
    );
    
    initial begin
        r1[0] = 5'd1;
        r1[1] = 5'd1;
        r1[2] = 5'd2;
        r1[3] = 5'd1;
        
        r2[0] = 5'd3;
        r2[1] = 5'd2;
        r2[2] = 5'd1;
        r2[3] = 5'd1;
    
        num_writes = 4;
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest[2] = 5'd1;
        dest[3] = 5'd1;
        dest_valid = 4'hf;
        stall_external = 0;

        #120;
        dest[0] = 5'd5;
        dest[1] = 5'd6;
        dest[2] = 5'd7;
        dest[3] = 5'd8;
        #20;
        $stop;
    
    
        r1[0] = 5'd1;
        r1[1] = 5'd2;
        r1[2] = 5'd3;
        r1[3] = 5'd4;
        
        r2[0] = 5'd1;
        r2[1] = 5'd2;
        r2[2] = 5'd3;
        r2[3] = 5'd4;
        num_writes = 4;
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest[2] = 5'd1;
        dest[3] = 5'd1;
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
        dest[0] = 5'd8;
        dest[2] = 5'd9;
        #20;
        x = 1;
        stall_external = 0;
        dest[1] = 5'd7;
        dest[3] = 5'd31;
        dest_valid = 4'b1010;
        #20;
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest_valid = 4'b0011;
        #20;
        num_writes = 0;
        dest_valid = 4'b0;
        #20;
        num_writes = 4;
        dest_valid = 4'b1111;
        dest[0] = 5'd1;
        dest[1] = 5'd2;
        dest[2] = 5'd3;
        dest[3] = 5'd4;
        #600;
        num_writes = 1;
        dest_valid = 4'b1;
        dest[0] = 5'd5;
        #20;
        DUT.buffer.completed_entry[1] = 1;
        #40;
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
