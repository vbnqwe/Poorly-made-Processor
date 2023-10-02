`timescale 1ns / 1ps

//quick note: branch_id corresponds to physical destination register
//this means that branches will allocate a register unnecessarily

module rename_top_2(
        input clk,
        //standard instruction inputs
        input [4:0] dest [4], //destination logical register
        input [4:0] r1 [4], 
        input [4:0] r2 [4],
        input [3:0] dest_needed, //low for things like store, high for things like add
        input stall_external, //if a stall further down the pipeline occurs
        input [3:0] if_branch, //if an instruction is a branch
        output [5:0] branch_id [4], //used for identifying branches, corresponds to destination register?
        //committing inputs
        input [31:0] committed_data [4],
        input [3:0] committed_valid,
        input [5:0] committed_dest [4], //where to commit
        //branch consistency inputs
        input [3:0] prv, //prediction result valid: if pred value is valid or garbage
        input [3:0] pred, //prediction: if a branch was correctly evaluated
        input [5:0] pred_id, //used to match to branch_id 
        //data outputs
        output [5:0] phys_dest [4], //physical register to write to at end of instruction
        output [31:0] r1_data [4],
        output [31:0] r2_data [4],
        output [3:0] r1_data_valid, //if r1/r2_data exists or will need to gotten from bus
        output [3:0] r2_data_valid,
        output [3:0] r1_data_needed,
        output [3:0] r2_data_needed,
        output [5:0] r1_look_for [4], //what physical register to look in bus for if data is not valid right now
        output [5:0] r2_look_for [4],
        output stall_internal //if rename stage needs to stall (no physical regs left)
    );
    
    
    ARF2 arf(
    
    );
    
    RAT2 rat(
    
    );
    
    ROB2 rob(
    
    );
    
endmodule
