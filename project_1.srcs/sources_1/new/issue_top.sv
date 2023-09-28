`timescale 1ns / 1ps


module issue_top(
    input clk,
    input [31:0] r1_data [4], 
    input [31:0] r2_data [4],
    input r1_data_valid [4], //if instruction requires this data
    input r2_data_valid [4],
    input r1_data_ready [4], //if data is correct and ready
    input r2_data_ready [4],
    input [6:0] r1_physical_reg [4], //location to look for if not ready
    input [6:0] r2_physical_reg [4],
    input [6:0] dest_physical_reg [4],
    input dest_valid [4],
    input instr_valid [4], //not sure if necessary yet
    input [31:0] completed_data [4],
    input [6:0] completed_physical_reg [4],
    input completed_valid [4],
    input stall,
    output [6:0] target_physical_reg [4],
    output [31:0] r1_out [4],
    output [31:0] r2_out [4],
    output output_valid [4] //if output is valid instruction
    );
    
    wire [2:0] instr_needed;
    wire [19:0] RS_ready;
    wire [4:0] RS_to_use [4];
    wire [3:0] RS_valid ;
    
    handler RSH(
        .clk,
        .instr_needed,
        .RS_ready,
        .RS_to_use,
        .RS_valid
    );
    
    wire if_using [20];
    
    genvar i;
    generate
        for(i = 0; i < 20; i = i + 1) begin : identifier 
            assign if_using[i] = ((RS_to_use[0] == i) & RS_valid[0]) | ((RS_to_use[1] == i) & RS_valid[1]) | 
                ((RS_to_use[2] == i) & RS_valid[2]) | ((RS_to_use[3] == i) & RS_valid[3]);
            RS Reservation_Station(
                .set(if_using[i])
            );
        end
        
    endgenerate
endmodule
