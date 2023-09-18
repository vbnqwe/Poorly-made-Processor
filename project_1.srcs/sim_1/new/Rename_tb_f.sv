`timescale 1ns / 1ps


module Rename_tb_f;

    parameter NUM_INSTRUCTIONS = 40;

    //module inputs
    bit clk;
    bit [2:0] num_writes;
    bit [4:0] dest[4];
    bit [4:0] r1 [4];
    bit [4:0] r2 [4];
    bit [3:0] dest_valid;
    bit stall_external;
    
    //module outputs
    bit [6:0] physical_dest [4];
    bit [3:0] physical_dest_valid;
    bit [3:0] r1_ready_out;
    bit [3:0] r2_ready_out;
    bit [6:0] r1_source [4];
    bit [6:0] r2_source [4];
    bit stall_internal;
    bit [3:0] completed_valid;
    bit [31:0] data_completed [4];
    bit [6:0] completed [4];

    //test variables - inputs
    reg [31:0] dest_t [NUM_INSTRUCTIONS];
    reg [31:0] r1_t [NUM_INSTRUCTIONS];
    reg [31:0] r2_t [NUM_INSTRUCTIONS];
    reg [31:0] return_data_t [NUM_INSTRUCTIONS];
    reg [31:0] num_cycles_t [NUM_INSTRUCTIONS];
    
       
    //test variables - values to compare to
    reg [31:0] r1_c [NUM_INSTRUCTIONS];
    reg [31:0] r2_c [NUM_INSTRUCTIONS];
    reg [31:0] rf_c [32];
    
    
    //test variables - store outputs
    reg [4:0] r1_o [NUM_INSTRUCTIONS];
    reg [4:0] r2_o [NUM_INSTRUCTIONS];
    reg [4:0] rf_o [NUM_INSTRUCTIONS];
    reg [31:0] r1_o_d [NUM_INSTRUCTIONS];
    reg [31:0] r2_o_d [NUM_INSTRUCTIONS];
    
    
    
    
    //other variables used
    reg [31:0] instruction_counter;
    reg [31:0] finished_instruction_counter;
    
    Test_storage_module tsm();
    
    assign dest_t = tsm.dest_t;
    assign r1_t = tsm.r1_t;
    assign r2_t = tsm.r2_t;
    assign return_data_t = tsm.return_data_t;
    assign num_cycles_t = tsm.num_cycles_t;
    
    assign r1_c = tsm.r1_c; 
    assign r2_c = tsm.r2_c;
    assign rf_c = tsm.rf_c;
    
    always @(posedge clk) begin
        instruction_counter <= instruction_counter + 1;
        
    end
    

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
    
    initial begin
        instruction_counter = 0;
    end
    
    always begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
endmodule
