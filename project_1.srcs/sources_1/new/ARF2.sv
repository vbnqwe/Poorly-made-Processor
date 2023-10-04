/*
Say you had:
add r9 = r1 + r4
add r1 = r2 + r3
add r4 = r1 + r5 
invalid instruction

how would you ensure that the correct value of r1 is passed along at each point


*/

module ARF2(
        input clk,
        input [4:0] new_dest [4],
        input [4:0] r1 [4], 
        input [4:0] r2 [4],
        input [4:0] commit_address [4],
        input [31:0] commit_data [4],
        input [3:0] commit_valid,
        output reg [31:0] r1_data [4],
        output reg [31:0] r2_data [4],
        output reg [3:0] r1_data_valid, r2_data_valid
    );
    
    reg [31:0] register_data [32];
    reg [31:0] register_data_valid;
    
    //set of data which may need to be used but is possibly made invalid by new set of instructions
    reg [31:0] backup_data [4];
    reg [4:0] backup_address [4];
    reg [3:0] backup_valid;
    
    wire [3:0] top_commit; //signal used to determine if the ith commit needs to be committed
    //if you write r1 in all 4 instructions, you only care about the last commit
    
    
    wire [3:0] if_r1_backup;
    wire [3:0] if_r2_backup;
    
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin
            always @(posedge clk) begin
                //write data if commits don't overlap/is latest commit
                if(top_commit[i]) begin
                    register_data[commit_address[i]] <= commit_data[i];
                    register_data_valid[commit_address[i]] <= 1;
                end
                
                //what was the reason for this?
                backup_data[i] <= register_data[new_dest[i]];
                backup_valid[i] <= register_data_valid[new_dest[i]];
                backup_address[i] <= new_dest[i];
            end   
                
            assign r1_data[i] = register_data[r1[i]];
            assign r2_data[i] = register_data[r2[i]];
            assign r1_data_valid[i] = register_data_valid[r1[i]];
            assign r2_data_valid[i] = register_data_valid[r2[i]];
        end
    endgenerate
    
    
    
    
    //generate top_commit signals
    assign top_commit[0] = !((commit_valid[1] & (commit_address[1] == commit_address[0])) | (commit_valid[2] & 
        (commit_address[2] == commit_address[0])) | (commit_valid[3] & (commit_address[3] == commit_address[0])));
    assign top_commit[1] = !((commit_valid[2] & (commit_address[2] == commit_address[1])) | (commit_valid[3] & 
        (commit_address[3] == commit_address[1])));
    assign top_commit[2] = !(commit_valid[3] & (commit_address[3] == commit_address[2]));
    assign top_commit[3] = 1;
    
    
endmodule