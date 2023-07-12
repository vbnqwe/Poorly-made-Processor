`timescale 1ns / 1ps


module Fetch_stage(
        input clk,
        output reg [31:0] instructions [4]
    );
    
    reg [31:0] core [32];
    
    initial begin
        core[0] = 32'h00a58633;
        core[1] = 32'h00a58633;
        core[2] = 32'h00a58633;
        core[3] = 32'h00a58633;
    end
    
    always @(posedge clk) begin
        instructions[0] = core[0];
        instructions[1] = core[1];
        instructions[2] = core[2];
        instructions[3] = core[3];
    end
    
endmodule
