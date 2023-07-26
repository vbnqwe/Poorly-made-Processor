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
    wire [3:0] r1_complete, r2_complete;
    
    wire [31:0] committed [8];
    wire [4:0] committed_dest [8];
    wire [7:0] committed_valid;
    
    wire [6:0] r1_rob_val [4];
    wire [6:0] r2_rob_val [4];
    wire [3:0] r1_rewritten;
    wire [3:0] r2_rewritten;
    
    wire [6:0] r1_target_pre_write [4];
    wire [6:0] r2_target_pre_write [4];
    wire [3:0] r1_ARF_or_ROB_pre_write;
    wire [3:0] r2_ARF_or_ROB_pre_write;
    wire [3:0] r1_ROB_ready;
    wire [3:0] r2_ROB_ready;
    
    wire [3:0] r1_val_exists, r2_val_exists;
    
    genvar a;
    generate
        for(a = 0; a < 4; a = a + 1) begin
            assign r1_target_pre_write[a] = r1_ready[a] ? r1_out_ARF[a] : r1_out_ROB[a];
            assign r1_ARF_or_ROB_pre_write[a] = r1_ready[a];
            
            assign r2_target_pre_write[a] = r2_ready[a] ? r2_out_ARF[a] : r2_out_ROB[a];
            assign r2_ARF_or_ROB_pre_write[a] = r2_ready[a];
            
            assign r1_source[a] = r1_rewritten[a] ? r1_rob_val[a] : r1_target_pre_write[a];
            assign r2_source[a] = r2_rewritten[a] ? r2_rob_val[a] : r2_target_pre_write[a];
            
            //does the value exist in some location or is it still somewhere up to pipeline
            assign r1_val_exists[a] = (!r1_rewritten[a]) & (r1_ready[a] | r1_complete[a]);
            assign r2_val_exists[a] = (!r2_rewritten[a]) & (r2_ready[a] | r2_complete[a]);
            
            assign r1_ready_out[a] = r1_val_exists[a];
            assign r2_ready_out[a] = r2_val_exists[a];
            
        end
    endgenerate
    

    
    ARF reg_file(
        .logical_dest (dest),
        .logical_dest_valid (dest_valid),
        .clk (clk),
        .physical_dest (allocated),
        .no_available (no_available),  
        .stall_external(stall_external),     
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
        .stall_external(stall_external),
        .dest (dest), 
        .r1 (r1_tag), 
        .r2 (r2_tag), 
        .r1_ready (r1_ROB_ready), 
        .r2_ready (r1_ROB_ready),
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
        .r1_complete (r1_complete),
        .r2_complete (r2_complete)
    );
    
    read_logic_module rlm(
        .dest (dest),
        .r1 (r1),
        .r2 (r2),
        .dest_valid (dest_valid),
        .newest (prev_newest),
        .r1_rob_val (r1_rob_val),
        .r2_rob_val (r2_rob_val),
        .r1_rewritten (r1_rewritten),
        .r2_rewritten (r2_rewritten)
    );
endmodule
