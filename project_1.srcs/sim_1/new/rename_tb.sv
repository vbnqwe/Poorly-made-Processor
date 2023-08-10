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
    bit [6:0] completed [4];
    bit [31:0] data_completed [4];
    bit [3:0] completed_valid;
    
    wire [6:0] physical_dest [4];
    wire [3:0] physical_dest_valid;
    wire [3:0] r1_ready_out, r2_ready_out;
    wire [6:0] r1_source [4];
    wire [6:0] r2_source [4];
    wire stall_internal;
    
    wire [6:0] tag [32];
    wire valid_arf [32];
    wire valid_rob [128];
    wire completed_1 [128];
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
    assign completed_1 = DUT.buffer.completed_entry;
    assign dest_rob = DUT.buffer.dest_reg;
    assign committed_dest = DUT.reg_file.committed_dest;
    assign allocated = DUT.allocated;
    assign prev_dest = DUT.reg_file.prev_dest;
    assign tag_to_write = DUT.reg_file.tag_to_write;
    
    wire [31:0] total_data [32];
    assign total_data = DUT.reg_file.core;
    
    
    wire [4:0] prev_dest1 [4];
    assign prev_dest1 = DUT.reg_file.prev_dest1;
    wire [6:0] tag_to_write [4];
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
        .stall_internal,
        .completed_valid,
        .data_completed,
        .completed
    );
    
    assign num_writes = dest_valid[0] + dest_valid[1] + dest_valid[2] + dest_valid[3];
    
    initial begin
        completed_valid = 4'b0;
        stall_external = 0;
        dest[0] = 5'd9;
        dest[1] = 5'd12;
        dest[2] = 5'd9;
        dest[3] = 5'd11;
        dest_valid[0] = 0;
        dest_valid[1] = 1;
        dest_valid[2] = 0;
        dest_valid[3] = 1;
        r1[0] = 5'd3;
        r1[1] = 5'd22;
        r1[2] = 5'd17;
        r1[3] = 5'd19;
        r2[0] = 5'd30;
        r2[1] = 5'd14;
        r2[2] = 5'd17;
        r2[3] = 5'd6;
        #20;
        
        completed_valid = 4'b0010;
        completed[1] = 7'd1;
        data_completed[1] = 32'd12;
        dest[0] = 5'd7;
        dest[1] = 5'd30;
        dest[2] = 5'd7;
        dest[3] = 5'd8;
        dest_valid[0] = 1;
        dest_valid[1] = 0;
        dest_valid[2] = 0;
        dest_valid[3] = 1;
        r1[0] = 5'd12;
        r1[1] = 5'd13;
        r1[2] = 5'd30;
        r1[3] = 5'd3;
        r2[0] = 5'd30;
        r2[1] = 5'd28;
        r2[2] = 5'd19;
        r2[3] = 5'd27;
        #20;
        
        completed_valid = 4'b0;
        dest[0] = 5'd31;
        dest[1] = 5'd24;
        dest[2] = 5'd11;
        dest[3] = 5'd27;
        dest_valid[0] = 0;
        dest_valid[1] = 1;
        dest_valid[2] = 0;
        dest_valid[3] = 1;
        r1[0] = 5'd12;
        r1[1] = 5'd5;
        r1[2] = 5'd28;
        r1[3] = 5'd19;
        r2[0] = 5'd26;
        r2[1] = 5'd31;
        r2[2] = 5'd22;
        r2[3] = 5'd13;
        #20;
        
        dest[0] = 5'd28;
        dest[1] = 5'd22;
        dest[2] = 5'd26;
        dest[3] = 5'd22;
        dest_valid[0] = 1;
        dest_valid[1] = 1;
        dest_valid[2] = 1;
        dest_valid[3] = 1;
        r1[0] = 5'd27;
        r1[1] = 5'd16;
        r1[2] = 5'd22;
        r1[3] = 5'd30;
        r2[0] = 5'd14;
        r2[1] = 5'd14;
        r2[2] = 5'd18;
        r2[3] = 5'd29;
        #20;
        
        dest[0] = 5'd13;
        dest[1] = 5'd0;
        dest[2] = 5'd16;
        dest[3] = 5'd2;
        dest_valid[0] = 1;
        dest_valid[1] = 1;
        dest_valid[2] = 0;
        dest_valid[3] = 0;
        r1[0] = 5'd15;
        r1[1] = 5'd6;
        r1[2] = 5'd23;
        r1[3] = 5'd22;
        r2[0] = 5'd20;
        r2[1] = 5'd16;
        r2[2] = 5'd18;
        r2[3] = 5'd2;
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
