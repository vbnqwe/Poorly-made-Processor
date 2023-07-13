`timescale 1ns / 1ps


module ARF_tb(

    );
    
    bit clk;
    bit [4:0] dest [4];
    bit [6:0] physical_reg [4];
    bit no_available;
    bit [3:0] dest_valid;
    
    wire [4:0] rob_tag [32];
    wire rob_tag_valid [32];
    wire test;
    assign test = 1;
    
    ARF DUT(.clk, .dest, .physical_reg, .no_available, .dest_valid);
    
    assign rob_tag = DUT.rob_tag;
    assign rob_tag_valid = DUT.rob_tag_valid;
    
    initial begin
        dest[0] = 1;
        dest[1] = 2;
        dest[2] = 3;
        dest[3] = 4;
        no_available = 0;
        physical_reg[0] = 1;
        dest_valid = 4'b0001;
        #20;
        $stop;
    end
    
    always begin 
        clk = 0;
        #10;
        clk = 1;
        #10;
    end
endmodule
