`timescale 1ns / 1ps
/*
Reservation Station Handler
On posedge clk will read state of all Reservation stations
then will assign 
*/

module RSH(
        input clk,
        input [2:0] instr_needed,
        input [19:0] RS_ready,
        output reg [4:0] RS_to_use [4],
        output reg [3:0] RS_valid 
    );
    
    parameter NUM_RS = 20;
    reg [4:0] count;
    
    always @(posedge clk) begin
        count = 0;
        RS_valid = 4'b0;
        for(int i = 0; i < NUM_RS; i = i + 1) begin
            if(RS_ready[i] & (instr_needed > count)) begin
                RS_to_use[count] = i;
                RS_valid[count] = 1;
                count = count + 1;
            end
        end
    end
    
endmodule
