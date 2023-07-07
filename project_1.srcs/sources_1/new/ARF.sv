`timescale 1ns / 1ps
/*
Inputs:
    -rX/rX_valid: if rX_valid[i] is high, then will read out rX[i]
    -dest/dest_valid: same as rX/rX_valid, but with additional logic for connecting to ROB

Outputs:
*/

module ARF(
        input [4:0] r1 [4],
        input [4:0] r2 [4],
        input [3:0] r1_valid,
        input [3:0] r2_valid,
        input [4:0] dest [4],
        input [3:0] dest_valid
    );
endmodule
