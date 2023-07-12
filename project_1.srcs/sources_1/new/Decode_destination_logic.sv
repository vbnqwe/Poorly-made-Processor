`timescale 1ns / 1ps


module delay_test(
        input [3:0] if_reg,
        input [4:0] dest [4],
        output reg [4:0] sorted [4],
        output reg [1:0] ordering [4],
        output reg [3:0] valid
    );
    

    
    
    always_comb begin
        if(if_reg[0]) begin
            sorted[0] = dest[0];
            ordering[0] = 2'd0;
            valid[0] = 1;
        end else if(!if_reg[0] & if_reg[1]) begin
            sorted[0] = dest[1];
            ordering[0] = 2'd1;
            valid[0] = 1;
        end else if(!if_reg[0] & !if_reg[1] & if_reg[2]) begin
            sorted[0] = dest[2];
            ordering[0] = 2'd2;
            valid[0] = 1;
        end else if(!if_reg[0] & !if_reg[1] & !if_reg[2] & if_reg[3]) begin
            sorted[0] = dest[3];
            ordering[0] = 2'd3;
            valid[0] = 1;
        end else 
            valid[0] = 0;
        
        if(if_reg[0] & if_reg[1]) begin
            sorted[1] = dest[1];
            ordering[1] = 2'd1;
            valid[1] = 1;
        end else if((if_reg[0] ^ if_reg[1]) & if_reg[2]) begin
            sorted[1] = dest[2];
            ordering[1] = 2'd2;
            valid[1] = 1;
        end else if((^if_reg[2:0]) & !(if_reg[2:0]) & if_reg[3]) begin
            sorted[1] = dest[3];
            ordering[1] = 2'd3;
            valid[1] = 1;
        end else 
            valid[1] = 0;
        
        if(if_reg[0] & if_reg[1] & if_reg[2]) begin
            sorted[2] = dest[2];
            ordering[2] = 2'd2;
            valid[2] = 1;
        end else if(!(^if_reg[2:0]) & if_reg[3]) begin
            sorted[2] = dest[3];
            ordering[2] = 2'd3;
            valid[2] = 1;
        end else
            valid[2] = 0;
        
        if(&if_reg[3:0]) begin
            sorted[3] = dest[3];
            ordering[3] = 2'd3;
            valid[3] = 1;
        end else
            valid[3] = 0;
    end
    
    
endmodule
