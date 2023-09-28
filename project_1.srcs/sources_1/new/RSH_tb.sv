`timescale 1ns / 1ps


module RSH_tb(

    );
    
    bit clk;
    
    parameter X = 128;
    
    reg [19:0] RS_ready;
    reg [2:0] instr_needed;
    reg [4:0] RS_to_use [4];
    reg [3:0] RS_valid;
    
    RSH DUT(
        .RS_ready,
        .instr_needed ,
        .clk,
        .RS_to_use,
        .RS_valid
    );
    
    initial begin
        RS_ready = 20'b0000000000000000001;
        instr_needed = 3;
        #2;
        $stop;
    end
    
    always begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
endmodule
