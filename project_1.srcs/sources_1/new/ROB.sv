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
        output no_available
    );   
    
    //tags
    reg [N_phys_regs-1:0] oldest, newest;
    reg [7:0] oldest_prev;
    reg [7:0] newest_prev;
    
    reg started; //Initial condition stuff (shouldnt be necessary??)
    
    //Flags for when things complete
    wire ready_to_commit [8];
    reg [3:0] allocation_failure; //for i = 1 to 4, if ith bit is 0, that means that newest + i register is in use

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
        for(int i = 0; i < SIZE; i++) begin
            valid_entry[i] = 0;
            completed_entry[i] = 0;
        end
    end
    
    
    always @(posedge clk) begin
        oldest_prev = oldest;
        newest_prev = newest;
    end
    
    assign no_available = |allocation_failure;
    assign newest = !no_available ? (newest_prev + x) : newest_prev; //shouldn't cause any issues but I don't trust this
    
    
    
    /*
    Generate logic used for physical register allocation
    */
    genvar c;
    generate
        for(c = 0; c < 4; c = c + 1) begin
            always @(posedge clk) begin
                if(x > c) begin
                    if((newest_prev + 1 + c) >= SIZE) begin
                        //check if entry is valid at (newest + 1) % SIZE
                        if(valid_entry[(newest_prev + 1 + c) % SIZE] == 0) begin
                            //assign at (newest + 1) % SIZE 
                            valid_entry[(newest_prev + 1 + c) % SIZE] = 1;
                            completed_entry[(newest_prev + 1 + c) % SIZE] = 0;
                            dest_reg[(newest_prev + 1 + c) % SIZE] = dest[0];
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
                            dest_reg[newest_prev + 1 + c] = dest[0];
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
    endgenerate
endmodule

