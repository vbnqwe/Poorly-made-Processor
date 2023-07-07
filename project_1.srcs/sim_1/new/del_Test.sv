`timescale 1ns / 1ps


module del_Test(

    );
    
    bit [3:0] if_reg;
    bit [4:0] dest [4];
    bit clk;
    wire [4:0] sorted[4];
    
    delay_test DUT (.if_reg, .dest, .clk, .sorted);
    
    initial begin
        
    end
    
endmodule
