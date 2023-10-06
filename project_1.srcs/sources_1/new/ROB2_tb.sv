`timescale 1ns / 1ps


module ROB2_tb();
    parameter SC = 4;
    parameter BE = 5;
    bit clk;
    bit stall_external;
    bit branch_mispredict;
    bit [4:0] new_dest [SC];
    bit [SC-1:0] new_dest_valid;
    bit [BE:0] r1 [SC];
    bit [BE:0] r2 [SC];
    bit [BE:0] completed_dest [SC];
    bit [31:0] completed_data [SC];
    bit [SC-1:0] completed_valid;
    wire [31:0] r1_data [SC];
    wire [31:0] r2_data [SC];
    wire [SC-1:0] r1_valid;
    wire [SC-1:0] r2_valid;
    wire [BE:0] r1_physical_dest [SC];
    wire [BE:0] r2_physical_dest [SC];
    wire [31:0] commit_data [SC];
    wire [BE:0] commit_source [SC];
    wire [SC-1:0] commit_valid;
    wire stall_internal;
    
    ROB2 DUT(
        .clk, .stall_external, .branch_mispredict, .new_dest, .new_dest_valid, .r1, .r2, .completed_dest,
        .completed_data, .completed_valid, .r1_data, .r2_data, .r1_valid, .r2_valid, .r1_physical_dest,
        .r2_physical_dest, .commit_data, .commit_source, .commit_valid, .stall_internal
    );
    
    initial begin
    
    end

endmodule
