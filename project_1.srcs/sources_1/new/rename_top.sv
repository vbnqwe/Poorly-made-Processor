`timescale 1ns / 1ps


module rename_top(
        input clk,
        input [4:0] dest [4],
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input [3:0] dest_valid,
        input stall_external,
        output [6:0] physical_dest [4],
        output [3:0] physical_dest_valid,
        output [31:0] r1_out [4],
        output [31:0] r2_out [4],
        output stall_internal
    );
    
    wire [6:0] allocated [4];
    wire no_available;

    
    ARF reg_file(
        .logical_dest (dest),
        .logical_dest_valid (dest_valid),
        .clk (clk),
        .physical_dest (allocated),
        .no_available (no_available),       
        .r1 (),          
        .r2 (),           
        .r1_out (),    
        .r2_out (),
        .r1_ready (),
        .r2_ready ()
    );
    
    
    ROB buffer(
        .num_writes (),
        .clk (),
        .if_reg (), 
        .dest (), 
        .r1 (), 
        .r2 (), 
        .r1_valid (), 
        .r2_valid (),
        .r1_out (), 
        .r2_out (),
        .no_available (no_available),
        .allocated (allocated),
        .committed (),
        .committed_dest (),
        .committed_source (),
        .num_commits (),
        .num_available_out ()//just num available, used for ARF
    );
endmodule
