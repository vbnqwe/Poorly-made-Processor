`timescale 1ns / 1ps

module RLM_tb(
        
    );
    
    bit clk;
    bit [4:0] dest_in [4];
    bit [4:0] r1_in [4];
    bit [4:0] r2_in [4];
    bit [3:0] dest_valid_in;
    bit [6:0] newest;
    wire [6:0] r1_read_from [4];
    wire [6:0] r2_read_from [4];
    wire [3:0] r1_ARF_or_ROB;
    wire [3:0] r2_ARF_or_ROB;
    
    wire [4:0] dest [4];
    wire [4:0] r1 [4];
    wire [4:0] r2 [4];
    wire [3:0] dest_valid;
    
    assign dest = DUT.dest;
    assign r1 = DUT.r1;
    assign r2 = DUT.r2;
    assign dest_valid = DUT.dest_valid;
    
    
    read_logic_module DUT(
        .clk,
        .dest_in,
        .r1_in,
        .r2_in,
        .dest_valid_in,
        .newest,
        .r1_read_from,
        .r2_read_from,
        .r1_ARF_or_ROB,
        .r2_ARF_or_ROB
    );    
    
    initial begin
        dest_in[0] = 5'd1;
        dest_in[1] = 5'd2;
        dest_in[2] = 5'd1;
        dest_in[3] = 5'd1;
        r1_in[0] = 5'd1;
        r1_in[1] = 5'd1;
        r1_in[2] = 5'd2;
        r1_in[3] = 5'd1;
        r2_in[0] = 5'd3;
        r2_in[1] = 5'd2;
        r2_in[2] = 5'd1;
        r2_in[3] = 5'd1;
        dest_valid_in = 4'hf;
        newest = 7'd0;
        #20;
        dest_in[0] = 5'd6;
        dest_in[1] = 5'd7;
        dest_in[2] = 5'd1;
        dest_in[3] = 5'd9;
        #20;
        dest_in[0] = 5'd1;
        dest_in[1] = 5'd2;
        dest_in[2] = 5'd1;
        dest_in[3] = 5'd1;
        #20;
        $stop;
    end
    
    always begin
        clk = 0;
        #10;
        clk = 1;
        #10;        
    end
    
endmodule
