`timescale 1ns / 1ps


module ARF_tb(

    );
    
    bit [4:0] logical_dest [4];
    bit [3:0] logical_dest_valid;
    bit clk;                     
    bit [6:0] physical_dest [4]; 
    bit no_available;          
    
    wire [6:0] tag [32];
    wire set_tag [32];
    
    ARF DUT(.logical_dest, .logical_dest_valid, .clk, .physical_dest, .no_available);
    
    assign tag = DUT.tag;
    assign set_tag = DUT.set_tag;
    
    initial begin
        logical_dest[0] = 1;
        logical_dest[1] = 2;
        logical_dest[2] = 3;
        logical_dest[3] = 4;
        logical_dest_valid = 4'b0110;
        no_available = 0;
        physical_dest[1] = 1;
        physical_dest[2] = 2;
        #20;
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
