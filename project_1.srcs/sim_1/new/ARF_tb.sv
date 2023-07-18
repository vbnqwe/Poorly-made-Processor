`timescale 1ns / 1ps


module ARF_tb(

    );
    bit [4:0] committed_dest [8];
    bit [7:0] committed_valid;
    bit [4:0] logical_dest [4];
    bit [3:0] logical_dest_valid;
    bit clk;                     
    bit [6:0] physical_dest [4]; 
    bit no_available;          
    
    wire [6:0] tag [32];
    wire set_tag [32];
    wire valid [32];
    wire highest_priority [4];
    
    ARF DUT(.logical_dest, .logical_dest_valid, .clk, .physical_dest, .no_available, .committed_dest, .committed_valid);
    
    assign tag = DUT.tag;
    assign set_tag = DUT.set_tag;
    assign valid = DUT.valid;
    assign highest_priority = DUT.highest_priority;
    
    initial begin
        committed_valid = 8'b0;
        logical_dest[0] = 1;
        logical_dest[1] = 2;
        logical_dest[2] = 3;
        logical_dest[3] = 4;
        logical_dest_valid = 4'b1111;
        no_available = 0;
        physical_dest[0] = 1;
        physical_dest[1] = 2;
        physical_dest[2] = 3;
        physical_dest[3] = 4;
        #20;
        logical_dest_valid = 4'b1001;
        physical_dest[0] = 5;
        physical_dest[3] = 6;
        #20;
        logical_dest_valid = 4'b0010;
        physical_dest[1] = 7;
        committed_valid[0] = 1;
        committed_dest[0] = 2;
        committed_valid[1] = 1;
        committed_dest[1] = 3;
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
