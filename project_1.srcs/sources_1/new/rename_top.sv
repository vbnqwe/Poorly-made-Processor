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
        output [3:0] r1_ready_out, r2_ready_out,
        output [6:0] r1_source [4],
        output [6:0] r2_source [4],
        output stall_internal
    );
    
    wire [6:0] allocated [4];
    wire no_available;
    wire if_stall;
    wire [6:0] prev_newest;
    
    
    wire [31:0] r1_out_ARF [4];
    wire [31:0] r2_out_ARF [4];
    wire [31:0] r1_out_ROB [4];
    wire [31:0] r2_out_ROB [4];
    
    wire [6:0] r1_tag [4];
    wire [6:0] r2_tag [4];
    wire [3:0] r1_ready, r2_ready;
    wire [3:0] r1_complete_ROB, r2_complete_ROB;
    wire [3:0] r1_ready_ROB, r2_ready_ROB; //note: this is if the value is valid
    
    wire [31:0] committed [8];
    wire [4:0] committed_dest [8];
    wire [7:0] committed_valid;
    
    wire [6:0] all_tags [32];
    wire all_valid [32];
    
    wire [6:0] r1_read_from [4];
    wire [6:0] r2_read_from [4];
    wire [4:0] r1_read_from_ARF [4];
    wire [4:0] r2_read_from_ARF [4];
    wire [3:0] r1_ARF_or_ROB;
    wire [3:0] r2_ARF_or_ROB;
    
    reg [4:0] r1_saved [4];
    reg [4:0] r2_saved [4];
    reg [4:0] dest_saved [4];
    reg [3:0] dest_valid_saved;
    
    always @(posedge clk) begin
        r1_saved <= r1;
        r2_saved <= r2;
        dest_saved <= dest;
        dest_valid_saved <= dest_valid;
    end
    
    genvar a;
    generate
        for(a = 0; a < 4; a = a + 1) begin
            assign r1_read_from_ARF[a] = r1_read_from[a][4:0];
            assign r2_read_from_ARF[a] = r2_read_from[a][4:0];
            assign r1_source[a] = r1_read_from[a];
            assign r2_source[a] = r2_read_from[a];
            assign r1_out[a] = r1_ARF_or_ROB ? r1_out_ARF[a] : r1_out_ROB[a];
            assign r2_out[a] = r2_ARF_or_ROB ? r2_out_ARF[a] : r2_out_ROB[a];
            assign r1_ready_out[a] = r1_ARF_or_ROB[a] | (r1_ready_ROB[a] & r1_complete_ROB);
            assign r2_ready_out[a] = r2_ARF_or_ROB[a] | (r2_ready_ROB[a] & r2_complete_ROB);
        end
    endgenerate
    
    
    ARF reg_file(
        .logical_dest (dest),
        .logical_dest_valid (dest_valid),
        .clk (clk),
        .physical_dest (allocated),
        .no_available (no_available),  
        .stall_external(stall_external),     
        .r1 (r1_read_from_ARF),          
        .r2 (r1_read_from_ARF),           
        .committed (committed),
        .committed_dest (committed_dest),
        .committed_valid (committed_valid),
        .r1_out (r1_out_ARF),    
        .r2_out (r2_out_ARF),
        .r1_ready (r1_ready),
        .r2_ready (r2_ready),
        .r1_tag (r1_tag),
        .r2_tag (r2_tag),
        .all_valid (all_valid),
        .all_tags (all_tags)
    );
    
    
    ROB buffer(
        .num_writes (num_writes),
        .clk (clk),
        .if_reg (dest_valid), 
        .stall_external(stall_external),
        .dest (dest), 
        .r1 (r1_read_from), 
        .r2 (r2_read_from), 
        .r1_ready (r1_ready_ROB), 
        .r2_ready (r1_ready_ROB),
        .r1_out (r1_out_ROB), 
        .r2_out (r2_out_ROB),
        .no_available (no_available),
        .allocated (allocated),
        .committed (committed),
        .committed_dest (committed_dest),
        .committed_source (),
        .num_commits (),
        .committed_valid (committed_valid),
        .num_available_out (),//just num available, used for ARF
        .prev_newest (prev_newest),
        .r1_complete (r1_complete_ROB),
        .r2_complete (r2_complete_ROB)
    );
    
    read_logic_module RLM(
        .clk (clk),
        .dest (dest_saved),
        .r1 (r1_saved),
        .r2 (r2_saved),
        .dest_valid (dest_valid_saved),
        .newest (prev_newest),
        .tags (all_tags),
        .valid_bits (all_valid),
        .r1_read_from (r1_read_from),
        .r2_read_from (r2_read_from),
        .r1_ARF_or_ROB (r1_ARF_or_ROB),
        .r2_ARF_or_ROB (r2_ARF_or_ROB)
    );
endmodule
