`timescale 1ns / 1ps


module rename_top(
        input clk,
        input [2:0] num_writes,
        input [4:0] dest [4],
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input [3:0] dest_valid,
        input stall_external,
        input [6:0] completed [4],
        input [31:0] data_completed [4],
        input [3:0] completed_valid,
        output [6:0] physical_dest [4],
        output [3:0] physical_dest_valid,
        output [31:0] r1_out [4],
        output [31:0] r2_out [4],
        output [3:0] r1_ready_out, r2_ready_out,
        output reg [6:0] r1_source [4],
        output reg [6:0] r2_source [4],
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

    
    wire [6:0] r1_read_from [4];
    wire [6:0] r2_read_from [4];
    wire [4:0] r1_read_from_ARF [4];
    wire [4:0] r2_read_from_ARF [4];
    wire [6:0] r1_read_from_ROB [4];
    wire [6:0] r2_read_from_ROB [4];
    wire [3:0] r1_dest_overwrite;
    wire [3:0] r2_dest_overwrite;
    
    assign r1_read_from_ARF = r1;
    assign r2_read_from_ARF = r2;
    
    genvar a;
    generate
        for(a = 0; a < 4; a = a + 1) begin
            assign r1_read_from_ROB[a] = r1_dest_overwrite[a] ? r1_tag[a] : r1_read_from[a];
            assign r2_read_from_ROB[a] = r2_dest_overwrite[a] ? r2_tag[a] : r2_read_from[a];
            
            assign r1_ready_out[a] = r1_dest_overwrite[a] & (r1_ready[a] | r1_complete_ROB[a]);
            assign r2_ready_out[a] = r2_dest_overwrite[a] & (r2_ready[a] | r2_complete_ROB[a]);
            
            always_comb begin
                if(!r1_dest_overwrite[a]) begin
                    r1_source[a] = r1_read_from[a];
                end else if (r1_ready[a]) begin
                    r1_source[a] = r1[a];
                end else begin
                    r1_source[a] = r1_tag[a];
                end
                
                if(!r2_dest_overwrite[a]) begin
                    r2_source[a] = r2_read_from[a];
                end else if (r2_ready[a]) begin
                    r2_source[a] = r2[a];
                end else begin
                    r2_source[a] = r2_tag[a];
                end
            end
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
        .r1 (r1_read_from), 
        .r2 (r2_read_from), 
        .completed(completed),
        .completed_data(data_completed),
        .completed_valid(completed_valid),
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
        .dest_in (dest),
        .r1_in (r1),
        .r2_in (r2),
        .dest_valid_in (dest_valid),
        .newest (prev_newest),
        .r1_read_from (r1_read_from),
        .r2_read_from (r2_read_from),
        .r1_ARF_or_ROB (r1_dest_overwrite),
        .r2_ARF_or_ROB (r2_dest_overwrite)
    );
endmodule
