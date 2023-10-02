`timescale 1ns / 1ps


module ARF2_tb(

    );
    
    bit clk;
    bit [4:0] new_dest [4];
    bit [4:0] r1 [4];
    bit [4:0] r2 [4];
    bit [4:0] commit_address [4];
    bit [31:0] commit_data [4];
    bit [3:0] commit_valid;
    wire [31:0] r1_data [4];
    wire [31:0] r2_data [4];
    wire [3:0] r1_data_valid, r2_data_valid;
    
    wire [31:0] backup_data [4];
    wire [4:0] backup_address [4];
    wire [3:0] backup_valid;
    
    assign backup_data = DUT.backup_data;
    assign backup_address = DUT.backup_address;
    assign backup_valid = DUT.backup_valid;
    
    wire [31:0] register_data [32];
    wire [31:0] register_data_valid;
    
    assign register_data = DUT.register_data;
    assign register_data_valid = DUT.register_data_valid;
    
    bit t1_true = 1;
    
    reg [31:0] backup_data_rec [4]; 
    reg [31:0] reg_file [32];
    initial begin
    
        //test 1: test if backup registers work and if commit works in simple scenario
        for(int i = 0; i < 32; i = i + 1) begin
            DUT.register_data[i] = 0;
        end
        DUT.register_data[0] = 1;
        DUT.register_data[1] = 2;
        DUT.register_data[2] = 3;
        DUT.register_data[3] = 4;
        DUT.register_data_valid = 32'hffffffff;
        new_dest[0] = 0;
        new_dest[1] = 1;
        new_dest[2] = 2;
        new_dest[3] = 3;
        commit_address[0] = 0;
        commit_address[1] = 1;
        commit_address[2] = 2;
        commit_address[3] = 3;
        commit_data[0] = 20;
        commit_data[1] = 20;
        commit_data[2] = 20;
        commit_data[3] = 20;
        commit_valid = 4'hf;
        #2;
        for(int i = 0; i < 4; i = i + 1) begin
            backup_data_rec[i] = backup_data[i];
        end
        for(int i = 0; i < 32; i = i + 1) begin
            reg_file[i] = DUT.register_data[i];
        end
        for(int i = 0; i < 4; i = i + 1) begin
            if(backup_data_rec[i] != (i + 1)) begin
                t1_true = 0;
            end
            
            if(reg_file[i] != 20) begin
                t1_true = 0;
            end
        end
        for(int i = 4; i < 32; i = i + 1) begin
            if(reg_file[i] != 0) begin
                t1_true = 0;
            end
        end
        
        if(t1_true) 
            $display("test 1 passed");
         else  
            $display("test 1 failed");
        $stop;
    end
    
    always begin
        clk = 0;
        #1; 
        clk = 1;
        #1;
    end
    
    ARF2 DUT(
        .clk,
        .new_dest,
        .r1,
        .r2,
        .commit_address,
        .commit_data,
        .commit_valid,
        .r1_data,
        .r2_data,
        .r1_data_valid,
        .r2_data_valid
    );
endmodule
