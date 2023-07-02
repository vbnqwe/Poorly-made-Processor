`timescale 1ns / 1ps

/*
Inputs: 
    -num_writes: number of physical registers that will be needed to be allocated
    -if_reg: low for instructions such as store where no register renaming needed, high enables renaming
    -dest: desitination register, on clk pulse will assign destination register a physical register
    -r1/r1_valid: if r1_valid is high, will read the r1 tag
    -r2/r2_valid: if r2_valid is high, will read the r2 tag
    -clk: no explanation needed
    
Outputs:
    -r1_out/r2_out: data stored in physical register, will be 0 if rX_valid is low
    -no_available: flag that is thrown high if all physical registers are currently busy

    
Behavior: 
    -On posedge clk, if physical register is avaiable, assign new instructions destination logical register
        to physical register. Write values to physical register entry in buffer. 
    -Asynchronously will write 
*/

module ROB #(parameter SIZE = 128, parameter N_phys_regs = 7, parameter N_instr = 4)(
        input logic [2:0] num_writes,
        input clk,
        input if_reg [N_instr], 
        input [4:0] dest [N_instr], 
        input [N_phys_regs-1:0] r1 [N_instr], 
        input [N_phys_regs-1:0] r2 [N_instr], 
        input r1_valid [N_instr], 
        input r2_valid [N_instr],
        output [31:0] r1_out [N_instr], 
        output [31:0] r2_out [N_instr],
        output reg no_available
    );   
    
    //tags
    reg [N_phys_regs-1:0] oldest, newest;
    reg [7:0] oldest_prev;
    reg [7:0] newest_prev;
    
    reg started; //Initial condition stuff (shouldnt be necessary??)
    
    //Flags for when things complete
    reg registers_allocated;
    reg oldest_complete;
    reg work_complete = registers_allocated & oldest_complete;
    wire ready_to_commit [8];

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
        oldest = 7'h7f;
    end
    
    
    always @(posedge clk) begin
        registers_allocated = 0;
        oldest_complete = 0;
        oldest_prev = oldest;
        newest_prev = newest;
    end
    
    always @(posedge clk) begin
        
        //allocate physical registers for new instructions
        //wrap around needed
        if((newest_prev + x) >= SIZE) begin
            //check if however many physical registers are needed exist
            
            //check if situation where num_writes = 4, oldest = 127, newest = 126
            if((oldest_prev > newest_prev)) begin
                //stall
                no_available = 1;

            end
            //check if situation where num_writes = 4, oldest = 1, newest = 127
            else if((oldest_prev < newest_prev) & (((newest_prev + x) % SIZE) >= oldest_prev)) begin
                //stall
                no_available = 1;
            end
            //can write registers, situation where num_writes = 4, oldest = 20, newest = 126
            else begin
                no_available = 0;
                
                //assign to registers
                if(x > 0) begin
                    if((newest_prev + 1) >= SIZE) begin
                        //assign at (newest + 1) % SIZE 
                        valid_entry[(newest_prev + 1) % SIZE] = 1;
                        completed_entry[(newest_prev + 1) % SIZE] = 0;
                        dest_reg[(newest_prev + 1) % SIZE] = dest[0];
                    end 
                    else begin
                        //assign at newest + 1
                        valid_entry[newest_prev + 1] = 1;
                        completed_entry[newest_prev + 1] = 0;
                        dest_reg[newest_prev + 1] = dest[0];
                    end
                end
                if(x > 1) begin
                    if((newest_prev + 2) >= SIZE) begin
                        //assign at (newest + 2) % SIZE 
                        valid_entry[(newest_prev + 2) % SIZE] = 1;
                        completed_entry[(newest_prev + 2) % SIZE] = 0;
                        dest_reg[(newest_prev + 2)] = dest[1];
                    end 
                    else begin
                        //assign at newest + 2
                        valid_entry[newest_prev + 2] = 1;
                        completed_entry[newest_prev + 2] = 0;
                        dest_reg[newest_prev + 2] = dest[1];
                    end
                end
                if(x > 2) begin
                    if((newest_prev + 3) >= SIZE) begin
                        //assign at (newest + 3) % SIZE 
                        valid_entry[(newest_prev + 3) % SIZE] = 1;
                        completed_entry[(newest_prev + 3) % SIZE] = 0;
                        dest_reg[(newest_prev + 3) % SIZE] = dest[2];
                    end 
                    else begin
                        //assign at newest + 3
                        valid_entry[newest_prev + 3] = 1;
                        completed_entry[newest_prev + 3] = 0;
                        dest_reg[newest + 3] = dest[2];
                    end
                end
                if(x > 3) begin
                    if((newest_prev + 4) >= SIZE) begin
                        //assign at (newest + 4) % SIZE 
                        valid_entry[(newest_prev + 4) % SIZE] = 1; 
                        completed_entry[(newest_prev + 4) % SIZE] = 0;
                        dest_reg[(newest_prev + 4) % SIZE] = dest[3];
                    end 
                    else begin
                        //assign at newest + 4
                        valid_entry[newest_prev + 4] = 1;
                        completed_entry[newest_prev + 4] = 0;
                        dest_reg[newest_prev + 4] = dest[3];
                    end
                end
            end
            //allocate data
            
            //change newest pointer
        end
        //no wrap around
        else begin
            //newest = 10, num_writes = 4, oldest = 12
            if((newest_prev + x) >= oldest_prev) begin
                //stall as this will take up a used register
                no_available = 1;
            end
            //newest = 10, num_writes = 4, oldest = 16
            else begin
                //write to registers
                no_available = 0;
                if(x > 0) begin
                    //assign at newest + 1
                    valid_entry[newest_prev + 1] = 1;
                    completed_entry[newest_prev + 1] = 0;
                    dest_reg[newest_prev + 1] = dest[0];
                end
                if(x > 1) begin
                    //assign at newest + 2
                    valid_entry[newest_prev + 2] = 1;
                    completed_entry[newest_prev + 2] = 0;
                    dest_reg[newest_prev + 2] = dest[1];
                end
                if(x > 2) begin
                    //assign at newest + 3
                    valid_entry[newest_prev + 3] = 1;
                    completed_entry[newest_prev + 3] = 0;
                    dest_reg[newest_prev + 3] = dest[2];
                end
                if(x > 3) begin
                    //assign at newest + 4
                    valid_entry[newest_prev + 4] = 1;
                    completed_entry[newest_prev + 4] = 0;
                    dest_reg[newest_prev + 4] = dest[3];
                end
            end
            
            
            
            //Handle removing registers ready to be stored
            if(valid_entry[oldest_prev] & completed_entry[oldest_prev]) begin
                
            end
        end
    end
    
    //ready to commit signal will be used to choose what values are outputted to be written in RD
    assign ready_to_commit[0] = valid_entry[oldest_prev] & completed_entry[oldest_prev];
    genvar c;
    generate
        for(c = 1; c < 8; c = c + 1) begin
            
        end
    endgenerate
endmodule
