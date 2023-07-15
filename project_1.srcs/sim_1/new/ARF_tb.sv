`timescale 1ns / 1ps


module ARF_tb(

    );
    
    bit a, b;
    wire c;
    
    ARF DUT(.a, .b, .c);
    
    initial begin
        a = 1;
        b = 0;
        #10;
        a = 0;
        #10;
        $stop;
    end
endmodule
