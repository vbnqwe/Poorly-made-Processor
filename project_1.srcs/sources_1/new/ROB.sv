`timescale 1ns / 1ps

/*
**Note:
4 instructions:
add r1 + r2 --> r3
instruction w/o writing to register
add r2 + r3 --> r4
instructions w/o writing to register

will be inputted into ROB as:
add r1 + r2 --> r3
add r2 + r3 --> r4
instruction w/o writing to reg
instruction w/o writing to reg

Logic will be needed outside of ROB to reorder to format above, while keeping track of correct order

Inputs: 
    -num_writes: number of physical registers that will be needed to be allocated
    -if_reg: low for instructions such as store where no register renaming needed, high enables renaming
    -dest: desitination register, on clk pulse will assign destination register a physical register
    -r1/r1_valid: if r1_valid is high, will read the r1 tag
    -r2/r2_valid: if r2_valid is high, will read the r2 tag
    -clk: no explanation needed
    
Outputs:
    -r1_out/r2_out: data stored in physical register, will be 0 if rX_valid is low
    -allocated: address of physical register, needs to be updated in ARF tag
    -no_available: flag that is thrown high if all physical registers are currently busy
    -committed: table of 8 entries where up to all 8 to none at all may be ready to be committed to ARF
    -committed_dest: destination register in ARF of commit
    -committed_source: the physical register address, if the 
    -num_commits: number of correct entries that are commits in committed output, eg if 3, then first 3 entries are commits

    
Behavior: 
    -On posedge clk, if physical register is avaiable, assign new instructions destination logical register
        to physical register. Write values to physical register entry in buffer. 
*/

module ROB #(parameter SIZE = 128, parameter N_phys_regs = 7, parameter N_instr = 4)(
        input logic [2:0] num_writes,
        input clk,
        input stall_external,
        input [N_instr-1:0] if_reg, 
        input [4:0] dest [N_instr], 
        input [N_phys_regs-1:0] r1 [N_instr], 
        input [N_phys_regs-1:0] r2 [N_instr], 
        output [31:0] r1_out [4], 
        output [31:0] r2_out [N_instr],
        output [3:0] r1_ready, r2_ready,
        output reg no_available,
        output reg [6:0] allocated [4],
        output reg [31:0] committed [8],
        output reg [4:0] committed_dest [8],
        output reg [6:0] committed_source [8],
        output [3:0] num_commits,
        output [7:0] committed_valid,
        output [2:0] num_available_out //just num available, used for ARF
    );   
    
    
    //tags
    reg [N_phys_regs-1:0] oldest, newest;
    reg [7:0] oldest_prev;
    reg [7:0] newest_prev;
    reg [7:0] eight_oldest [8];
    
    reg started; //Initial condition stuff (shouldnt be necessary??)
    
    //Flags for when things complete
    reg ready_to_commit [8];
    reg [3:0] allocation_failure; //for i = 1 to 4, if ith bit is 0, that means that newest + i register is in use
    reg [2:0] num_available; //calculates how many registers available to allocate on next cycle, from 0 to 4
    reg [3:0] available_counter;
    reg [2:0] num_available_stored; //store num_available on posedge

    //integer
    reg [N_phys_regs-1:0] x;
    assign x = {4'b0, num_writes};
    
    //data storage
    reg valid_entry [SIZE]; //Is entry being used in pipeline
    reg completed_entry [SIZE]; //Is entry completed
    reg [31:0] data [SIZE]; //data for register
    reg [4:0] dest_reg [SIZE];
    
    
    initial begin
        newest = 7'b0;
        //oldest = 7'b0;
        newest_prev = 7'b0;
        oldest_prev = 7'b1;
        allocation_failure = 4'b0;
        for(int i = 0; i < SIZE; i++) begin
            valid_entry[i] = 0;
            completed_entry[i] = 0;
        end
    end
    
    
    always @(posedge (clk & !stall_external)) begin
        oldest_prev = oldest;
        newest_prev = newest;
        newest = !no_available ? (newest_prev + x) : newest_prev;
        num_available_stored = num_available;
    end
    
    assign num_available_out = num_available;
    
    assign no_available = /*(|allocation_failure) | */(num_available != 4);
    //assign newest = !no_available ? (newest_prev + x) : newest_prev; //shouldn't cause any issues but I don't trust this

    
    /*
    Generate logic used for physical register allocation
    */
    /*
    genvar c;
    generate
        for(c = 0; c < 4; c = c + 1) begin
            always @(posedge clk) begin
                if((x > c) & (num_available_stored >= num_writes)) begin
                    if((newest_prev + 1 + c) >= SIZE) begin
                        //check if entry is valid at (newest + 1) % SIZE
                        if(valid_entry[(newest_prev + 1 + c) % SIZE] == 0) begin
                            //assign at (newest + 1) % SIZE if no previous allocation failurs
                            valid_entry[(newest_prev + 1 + c) % SIZE] = 1;
                            completed_entry[(newest_prev + 1 + c) % SIZE] = 0;
                            dest_reg[(newest_prev + 1 + c) % SIZE] = dest[c];
                            allocation_failure[c] = 0;
                        end
                        //(newest + 1) % SIZE is unavailable
                        else begin
                            allocation_failure[c] = 1;
                        end
                    end 
                    else begin
                        //check if entry is valid at newest + 1
                        if(valid_entry[newest_prev + 1 + c] == 0) begin
                            //assign at newest + 1
                            valid_entry[newest_prev + 1 + c] = 1;
                            completed_entry[newest_prev + 1 + c] = 0;
                            dest_reg[newest_prev + 1 + c] = dest[c];
                            allocation_failure[c] = 0;
                        end
                        //newest + 1 is unavailable
                        else begin
                            allocation_failure[c] = 1;
                        end
                    end
                end
                else begin
                    allocation_failure[c] = 0; //can't use resources you don't need
                end
            end
        end 
    endgenerate*/
    
    
    reg [2:0] offset [4];
    assign offset[0] = 0;
    assign offset[1] = if_reg[0];
    assign offset[2] = if_reg[1] + if_reg[0];
    assign offset[3] = if_reg[2] + if_reg[1] + if_reg[0];
    genvar c;
    generate
        for(c = 0; c < 4; c = c + 1) begin
            always @(posedge (clk & !stall_external)) begin
                if((num_available_stored == 4) & if_reg[c]) begin
                    if((newest_prev + 1 + offset[c]) >= SIZE) begin
                        //check if entry is valid at (newest + 1) % SIZE
                        if(valid_entry[(newest_prev + 1 + offset[c]) % SIZE] == 0) begin
                            //assign at (newest + 1) % SIZE if no previous allocation failurs
                            valid_entry[(newest_prev + 1 + offset[c]) % SIZE] = 1;
                            completed_entry[(newest_prev + 1 + offset[c]) % SIZE] = 0;
                            dest_reg[(newest_prev + 1 + offset[c]) % SIZE] = dest[c];
                            allocation_failure[c] = 0;
                            allocated[c] = (newest_prev + 1 + offset[c]) % SIZE;
                        end
                        //(newest + 1) % SIZE is unavailable
                        else begin
                            allocation_failure[c] = 1;
                        end
                    end 
                    else begin
                        //check if entry is valid at newest + 1
                        if(valid_entry[newest_prev + 1 + offset[c]] == 0) begin
                            //assign at newest + 1
                            valid_entry[newest_prev + 1 + offset[c]] = 1;
                            completed_entry[newest_prev + 1 + offset[c]] = 0;
                            dest_reg[newest_prev + 1 + offset[c]] = dest[c];
                            allocation_failure[c] = 0;
                            allocated[c] = (newest_prev + 1 + offset[c]);
                        end
                        //newest + 1 is unavailable
                        else begin
                            allocation_failure[c] = 1;
                        end
                    end
                end
            end
        end
    endgenerate
    
    
    
    //Generate ready_to_commit signals, which are used to determine what entries can be committed.
    assign ready_to_commit[0] = valid_entry[oldest_prev] & completed_entry[oldest_prev];    
    
    assign eight_oldest[0] = oldest_prev;
    genvar d;
    generate
        for(d = 1; d < 8; d = d + 1) begin
            always_comb begin
                //handle ready_to_commit bus and eight_oldest for address storage of potential commits
                //wrap around
                if((oldest_prev + d) >= SIZE) begin
                    eight_oldest[d] = (oldest_prev + d) % SIZE;
                    //prior entry also wraps around
                    if((oldest_prev + d - 1) >= SIZE) begin
                        ready_to_commit[d] = ready_to_commit[d - 1] & valid_entry[(oldest_prev + d) % SIZE] + completed_entry[(oldest_prev + d) % SIZE];
                    end
                    //prior entry does not wrap around
                    else begin
                        ready_to_commit[d] = ready_to_commit[d - 1] & valid_entry[(oldest_prev + d) % SIZE] & completed_entry[(oldest_prev + d) % SIZE];
                    end
                end
                //no wrap around
                else begin
                    eight_oldest[d] = oldest_prev + d;
                    ready_to_commit[d] = ready_to_commit[d - 1] & valid_entry[oldest_prev + d] & completed_entry[oldest_prev + d];
                end
            end
        end
    endgenerate
    
    assign num_commits = ready_to_commit[0] + ready_to_commit[1] + ready_to_commit[2] + ready_to_commit[3] + ready_to_commit[4] + ready_to_commit[5] + ready_to_commit[6] + ready_to_commit[7];
    
    
    genvar e;
    generate
        for(e = 0; e < 8; e = e + 1)begin
            assign committed_valid[e] = ready_to_commit[e];
            always_comb begin
                if(ready_to_commit[e]) begin
                    committed[e] = data[eight_oldest[e]];
                    committed_dest[e] = dest_reg[eight_oldest[e]];
                    committed_source[e] = eight_oldest[e];
                end
            end
            
            always @(posedge (clk & !stall_external)) begin
                if(ready_to_commit[e]) begin
                    valid_entry[eight_oldest[e]] = 0;
                    completed_entry[eight_oldest[e]] = 0;
                end
            end
        end    
    endgenerate
    
    
    //check how many available registers on next cycle up to 4 regs
    genvar f;
    generate
        for(f = 0; f < 4; f = f + 1) begin
            always_comb begin
                if((newest + f + 1) >= SIZE) begin
                    //check (newest + f + 1) % SIZE
                    if(valid_entry[(newest + f + 1) % SIZE] == 0) begin
                        available_counter[f] = 1;
                    end else begin
                        available_counter[f] = 0;
                    end
                end
                else begin
                    //check newest + f + 1
                    if(valid_entry[newest + f + 1] == 0) begin
                        available_counter[f] = 1;
                    end else begin
                        available_counter[f] = 0;
                    end
                end
            end
        end
    endgenerate
    
    always_comb begin
        oldest = 7'b1;
        oldest = oldest_prev + num_commits;
        
        if(available_counter[0] == 0) begin
            num_available = 3'd0;
        end else if((available_counter[0] == 1) & (available_counter[1] == 0)) begin
            num_available = 3'd1;
        end else if ((available_counter[0] == 1) & (available_counter[1] == 1) & (available_counter[2] == 0)) begin
            num_available = 3'd2;
        end else if ((available_counter[0] == 1) & (available_counter[1] == 1) & (available_counter[2] == 1) & (available_counter[3] == 0)) begin
            num_available = 3'd3;
        end else begin
            num_available = 3'd4;
        end
    end
    
    genvar g;
    generate 
        for(g = 0; g < 4; g = g + 1) begin
            assign r1_out[g] = data[r1[g]];
            assign r2_out[g] = data[r2[g]];
            assign r1_ready[g] = valid_entry[r1[g]];
            assign r2_ready[g] = valid_entry[r2[g]];
        end 
    endgenerate
    
endmodule

