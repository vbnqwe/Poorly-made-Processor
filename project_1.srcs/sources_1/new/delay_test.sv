`timescale 1ns / 1ps


module delay_test(
        input [3:0] if_reg,
        input [4:0] dest [4],
        input clk,
        output [4:0] sorted[4]
    );
    
    reg [4:0] temp [4];
    
    assign sorted = temp;
    
    always_comb begin
        if(if_reg[0])
            temp[0] = dest[0];
        else if(!if_reg[0] & if_reg[1])
            temp[0] = dest[1];
        else if(!if_reg[0] & !if_reg[1] & if_reg[2]) 
            temp[0] = dest[2];
        else if(!if_reg[0] & !if_reg[1] & !if_reg[2] & if_reg[3]) 
            temp[0] = dest[3];
        
        if(if_reg[0] & if_reg[1]) 
            temp[1] = dest[1];
        else if((if_reg[0] ^ if_reg[1]) & if_reg[2]) 
            temp[1] = dest[2];
        else if((^if_reg[2:0]) & !(if_reg[2:0]) & if_reg[3]) begin
            temp[1] = dest[3];
        end
        
        if(if_reg[0] & if_reg[1] & if_reg[2])
            temp[2] = dest[2];
        else if(!(^if_reg[2:0]) & if_reg[3]) 
            temp[2] = dest[3];
        
        if(&if_reg[3:0])
            temp[3] = dest[3];
    end
    
    
endmodule
