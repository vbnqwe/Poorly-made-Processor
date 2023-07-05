`timescale 1ns / 1ps


module delay_test(
        input a,
        input [2:0] t
        , output [2:0] out
    );
    
    reg [2:0] x;
    reg [2:0] y;
    
    assign y = t;
    
    assign out = x;
    
    
    assign x[0] = t[0];
    genvar d;
    generate
        for(d = 1; d < 3; d = d + 1) begin
            always_comb begin
                x[d] = x[d-1] & y[d];
            end
        end
    endgenerate
    
endmodule
