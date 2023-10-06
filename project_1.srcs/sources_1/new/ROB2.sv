
module ROB2
     #(parameter SC = 4,
        parameter ENTRIES = 64, //number of entries in ROB
        parameter BE = 5)(      //Bits Entries, used for [BE:0]; 2^(BE+1) = ENTRIES
        //other inputs
        input clk,
        input stall_external,
        input branch_mispredict,
        //next set of instructions
        input [4:0] new_dest [SC],
        input [SC-1:0] new_dest_valid,
        input [BE:0] r1 [SC],
        input [BE:0] r2 [SC],
        //completed - attachs to common data bus
        input [BE:0] completed_dest [SC],
        input [31:0] completed_data [SC],
        input [SC-1:0] completed_valid,
        //read data outputs
        output [31:0] r1_data [SC],
        output [31:0] r2_data [SC],
        output [SC-1:0] r1_valid,
        output [SC-1:0] r2_valid,
        output reg [BE:0] r1_physical_dest [SC],
        output [BE:0] r2_physical_dest [SC],
        //commit ouputs
        output reg [31:0] commit_data [SC],
        output reg [BE:0] commit_source [SC],
        output reg [SC-1:0] commit_valid,
        //other
        output reg stall_internal
        
    );

    //actual memory variables
    reg [31:0] entry [ENTRIES];
    reg entry_valid [ENTRIES];
    reg entry_complete [ENTRIES];
    reg [BE:0] allocation_pointer; //if allocation_pointer = 3, that means that entry[3] is the next location where
    //data may be stored
    reg [BE:0] top_instruction_pointer; //pointer used for tracking completed
    //if TIP = 3, that means that entry[3] will be checked for completion each cycle
    
    reg [BE:0] next_pointer;
    assign next_pointer = allocation_pointer + 4;
    
    reg if_allocating;
    reg [2:0] indexing [SC]; 
    /*
    if indexing[i] = 0, then don't write this instruction, else write to position indexing[i] - 1
    for example, indexing = {0, 1, 0, 2} means:
    instruction 0 does not write
    instruction 1 writes to pointer + indexing[1] - 1
    instruction 2 doesn't write
    instruction 3 writes to pointer + indexing[3] - 1
    */
    
    always_comb begin
        indexing[0] = new_dest_valid[0] ? 1 : 0;
        indexing[1] = new_dest_valid[1] ? (indexing[0] + 1) : 0;
        indexing[2] = new_dest_valid[2] ? (indexing[0] + indexing[1] + 1) : 0;
        indexing[3] = new_dest_valid[3] ? (indexing[0] + indexing[1] + indexing[2] + 1) : 0;
        
        //set instructions up for committing        
        if(entry_complete[top_instruction_pointer]) begin
            commit_data[0] = entry[top_instruction_pointer];
            commit_valid[0] = 1;
            commit_source[0] = top_instruction_pointer;
        end else begin
            commit_valid[0] = 0;
        end
        
        if(entry_complete[top_instruction_pointer] & entry_complete[top_instruction_pointer + 1]) begin
            commit_data[1] = entry[top_instruction_pointer + 1];
            commit_valid[1] = 1;
            commit_source[1] = top_instruction_pointer + 1;
        end else begin 
            commit_valid[1] = 0;
        end
        
        if(entry_complete[top_instruction_pointer] & entry_complete[top_instruction_pointer + 1] & 
            entry_complete[top_instruction_pointer + 2]) begin
            commit_data[2] = entry[top_instruction_pointer + 2];
            commit_valid[2] = 1;
            commit_source[2] = top_instruction_pointer + 2;
        end else begin
            commit_valid[2] = 0;
        end
        
        if(entry_complete[top_instruction_pointer] & entry_complete[top_instruction_pointer + 1] & 
            entry_complete[top_instruction_pointer + 2] & entry_complete[top_instruction_pointer + 3]) begin
            commit_data[3] = entry[top_instruction_pointer + 3];
            commit_valid[3] = 1;
            commit_source[3] = top_instruction_pointer + 3;
        end else begin
            commit_valid[3] = 0;
        end
    end
    
    initial begin
        for(int k = 0; k < ENTRIES; k = k + 1) begin
            entry[k] = 0;
            entry_valid[k] = 0;
            entry_complete[k] = 0;
            allocation_pointer = 0;
            top_instruction_pointer = 0;
        end
    end
    
    genvar i;
    generate
    
        for(i = 0; i < SC; i = i + 1) begin
            assign r1_data[i] = entry[r1[i]];
            assign r2_data[i] = entry[r2[i]];
            assign r1_valid[i] = entry_complete[r1[i]];
            assign r2_valid[i] = entry_complete[r2[i]];
            
            always_comb begin
                if(if_allocating & (indexing[i] != 0)) begin
                    entry_valid[allocation_pointer + indexing[i] - 1] = 1;
                    entry_complete[allocation_pointer + indexing[i] - 1] = 0;
                end
            end
            
            always @(posedge clk) begin
                if(!entry_valid[next_pointer]) begin
                    if_allocating = 1;
                    stall_internal = 0;
                end else begin
                    if_allocating = 0;
                    stall_internal = 1;
                end
            end
        end
        
    endgenerate
    
    always @(posedge clk) begin
        if(completed_valid[0]) begin
            entry[completed_dest[0]] <= completed_data[0];
            entry_complete[completed_dest[0]] <= 1;
        end
        if(completed_valid[1]) begin
            entry[completed_dest[1]] <= completed_data[1];
            entry_complete[completed_dest[1]] <= 1;
        end
        if(completed_valid[2]) begin
            entry[completed_dest[2]] <= completed_data[2];
            entry_complete[completed_dest[2]] <= 1;
        end
        if(completed_valid[3]) begin
            entry[completed_dest[3]] <= completed_data[3];
            entry_complete[completed_dest[3]] <= 1;
        end
        
        //remove registers that have been completed for 1 cycle
        if(entry_complete[top_instruction_pointer]) begin
            entry_complete[top_instruction_pointer] <= 0;
            entry_valid[top_instruction_pointer] <= 0;
            if(entry_complete[top_instruction_pointer + 1]) begin
                entry_complete[top_instruction_pointer + 1] <= 0;
                entry_valid[top_instruction_pointer + 1] <= 0;
                if(entry_complete[top_instruction_pointer + 2]) begin
                    entry_complete[top_instruction_pointer + 2] <= 0;
                    entry_valid[top_instruction_pointer + 2] <= 0;
                    if(entry_complete[top_instruction_pointer + 3]) begin
                        entry_complete[top_instruction_pointer + 3] <= 0;
                        entry_valid[top_instruction_pointer + 3] <= 0;
                        top_instruction_pointer <= top_instruction_pointer + 4;
                    end else begin
                        top_instruction_pointer <= top_instruction_pointer + 3;
                    end
                end else begin
                    top_instruction_pointer <= top_instruction_pointer + 2;
                end
            end else begin
                top_instruction_pointer <= top_instruction_pointer + 1;
            end
        end
    end
    
    
    
endmodule