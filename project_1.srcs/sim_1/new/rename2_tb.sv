`timescale 1ns / 1ps

/*
Main purpose of this testbench is to test if the rename stage can properly order instructions. A random set of instructions
is generated in an external program, along with the expect final output of the register file and the data and order of all 
commits (note that when instructions complete vary between the two, but it if rename stage works shouldn't be an issue).
Down the line will be editted for branch prediction and external pipeline stalls, but at the moment I just want this to 
work normally.
*/

module rename2_tb(
        
    );
    
    bit clk;
    bit [4:0] dest [4]; //destination logical register
    bit [4:0] r1 [4]; 
    bit [4:0] r2 [4];
    bit [3:0] dest_needed; //low for things like store, high for things like add
    bit stall_external; //if a stall further down the pipeline occurs
    bit [3:0] if_branch; //if an instruction is a branch
    wire [5:0] branch_id [4]; //used for identifying branches, corresponds to destination register?
    //committing inputs
    bit [31:0] committed_data [4];
    bit [3:0] committed_valid;
    bit [5:0] committed_dest [4]; //where to commit
    //branch consistency inputs
    bit [3:0] prv; //prediction result valid: if pred value is valid or garbage
    bit [3:0] pred; //prediction: if a branch was correctly evaluated
    bit [5:0] pred_id; //used to match to branch_id 
    //data outputs
    wire [5:0] phys_dest [4]; //physical register to write to at end of instruction
    wire [31:0] r1_data [4];
    wire [31:0] r2_data [4];
    wire [3:0] r1_data_valid; //if r1/r2_data exists or will need to gotten from bus
    wire [3:0] r2_data_valid;
    wire [3:0] r1_data_needed;
    wire [3:0] r2_data_needed;
    wire [5:0] r1_look_for [4]; //what physical register to look in bus for if data is not valid right now
    wire [5:0] r2_look_for [4];
    wire stall_internal; //if rename stage needs to stall (no physical regs left)
    
    
    //adjust testbench later, but first want to pass basic situation
    assign if_branch = 4'b0;
    assign stall_external = 0;
    
    rename_top_2 DUT(
        .clk,
        .dest,
        .r1,
        .r2,
        .dest_needed,
        .stall_external,
        .if_branch,
        .branch_id,
        .committed_data,
        .committed_valid,
        .committed_dest,
        .prv,
        .pred,
        .pred_id,
        .phys_dest,
        .r1_data,
        .r2_data,
        .r1_data_valid,
        .r2_data_valid,
        .r1_data_needed,
        .r2_data_needed,
        .r1_look_for,
        .r2_look_for,
        .stall_internal
    );
    
    parameter NUM_INSTRUCTIONS = 40;
    
    tb_mem_storage_module tb();
    
    //instruction inputs
    reg [31:0] dest_in [NUM_INSTRUCTIONS];
    reg [4:0] r1_in [NUM_INSTRUCTIONS];
    reg [4:0] r2_in [NUM_INSTRUCTIONS];
    reg [31:0] cycles_to_write_in [NUM_INSTRUCTIONS];
    reg if_valid_in [NUM_INSTRUCTIONS];
    reg if_add_in [NUM_INSTRUCTIONS];
    
    //expected outputs for each instruction, should be in order
    reg [4:0] commit_address_ex [NUM_INSTRUCTIONS];
    reg [31:0] commit_data_ex [NUM_INSTRUCTIONS];
    reg commit_valid_ex [NUM_INSTRUCTIONS];
    
    //actual commits that are tracked
    reg [4:0] commit_address_act [NUM_INSTRUCTIONS];
    reg [31:0] commit_data_act [NUM_INSTRUCTIONS];
    reg commit_valid_act [NUM_INSTRUCTIONS];
    reg [31:0] num_commits;
    
    //initial values for rf and expected final values
    reg [31:0] initial_rf [32];
    reg [31:0] final_rf [32];
    
    reg if_done;
    
    reg [31:0] cycle_queue [NUM_INSTRUCTIONS];
    reg [31:0] queue [NUM_INSTRUCTIONS];
    reg [4:0] queue_write_back [NUM_INSTRUCTIONS];
    reg [31:0] queue_back_pointer;
    reg [31:0] complete_counter;
    reg [31:0] to_complete_this_cycle [4];
        
    assign dest_in = tb.dest;
    assign r1_in = tb.r1;
    assign r2_in = tb.r2;
    assign cycles_to_write_in = tb.cycles_to_write;
    assign if_valid_in = tb.if_valid;
    assign if_add_in = tb.if_add;
    
    assign commit_address_ex = tb.commit_address;
    assign commit_data_ex = tb.commit_data;
    assign commit_valid_ex = tb.commit_valid;
    
    assign initial_rf = tb.initial_rf;
    assign final_rf = tb.final_rf;
    
    initial begin
        if_done = 0;
        num_commits = 0;
    end
    
    always begin
        clk = 0;
        #1;
        clk = 1;
        #1;
        if(if_done) 
            $stop;
    end
    
    /*on clock pulse:
        -decrement cycles left for each instruction in queue -done
        -queue up to 4 instructions for write back -done
        -all other complete instructions should be set to 1 cycle left -done
        -add new instructions to queue
        -check if queue is empty
            -if empty throw flag high
    */ 
    always @(posedge clk) begin       
        complete_counter = 0;
        
        //decrements all instructions in queue, prepares up to 4 to write back
        for(int i = 0; i < queue_back_pointer; i = i + 1) begin
            if(cycle_queue[i] > 0) begin
                cycle_queue[i] = cycle_queue[i] - 1;
                if(cycle_queue[i] == 0) begin
                    complete_counter = complete_counter + 1;
                    if(complete_counter <= 4) begin
                        //if possible to write back this cycle, write back
                        to_complete_this_cycle[complete_counter - 1] = i;
                    end else begin
                        //if not possible, don't write back
                        cycle_queue[i] = 1;
                    end
                end
            end
        end
        
        for(int i = 0; i < 4; i = i + 1) begin
            
        end
        
        //add new instructions to queue
        for(int i = 0; i < 4; i = i + 1) begin
        
        end
    end
endmodule
