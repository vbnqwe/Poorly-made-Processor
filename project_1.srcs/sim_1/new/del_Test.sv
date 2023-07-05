`timescale 1ns / 1ps


module del_Test(

    );
    
    bit a;
    bit [2:0] t;
    wire [2:0] out_test;
    
    delay_test DUT (.a(a), .t, .out(out_test));
    
    initial begin
        a = 1;
        t = 3'b111;
        #1;
        $stop;
    end
    
endmodule
