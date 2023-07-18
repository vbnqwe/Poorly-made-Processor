`timescale 1ns / 1ps


module rename_top(
        input clk,
        input [2:0] num_writes,
        input [4:0] dest [4],
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input [3:0] dest_valid,
        input stall_external,
        output [6:0] physical_dest [4],
        output [3:0] physical_dest_valid,
        output [31:0] r1_out [4],
        output [31:0] r2_out [4],
        output [3:0] r1_ready, r2_ready,
        output [6:0] r1_source [4],
        output [6:0] r2_source [4],
        output stall_internal
    );
    
    wire [6:0] allocated [4];
    wire no_available;
    
    
    wire [31:0] r1_out_ARF [4];
    wire [31:0] r2_out_ARF [4];
    wire [31:0] r1_out_ROB [4];
    wire [31:0] r2_out_ROB [4];
    
    wire [6:0] r1_tag [4];
    wire [6:0] r2_tag [4];
    wire [3:0] r1_ready, r2_ready;
    
    wire [31:0] committed [8];
    wire [4:0] committed_dest [8];
    wire [7:0] committed_valid;
    

    
    ARF reg_file(
        .logical_dest (dest),
        .logical_dest_valid (dest_valid),
        .clk (clk),
        .physical_dest (allocated),
        .no_available (no_available),       
        .r1 (r1),          
        .r2 (r2),           
        .committed (committed),
        .committed_dest (committed_dest),
        .committed_valid (committed_valid),
        .r1_out (r1_out_ARF),    
        .r2_out (r2_out_ARF),
        .r1_ready (r1_ready),
        .r2_ready (r2_ready),
        .r1_tag (r1_tag),
        .r2_tag (r2_tag)
    );
    
    
    ROB buffer(
        .num_writes (num_writes),
        .clk (clk),
        .if_reg (dest_valid), 
        .dest (dest), 
        .r1 (r1_tag), 
        .r2 (r2_tag), 
        .r1_ready (), 
        .r2_ready (),
        .r1_out (r1_out_ROB), 
        .r2_out (r2_out_ROB),
        .no_available (no_available),
        .allocated (allocated),
        .committed (committed),
        .committed_dest (committed_dest),
        .committed_source (),
        .num_commits (),
        .committed_valid (committed_valid),
        .num_available_out ()//just num available, used for ARF
    );
endmodule
