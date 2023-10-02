`timescale 1ns / 1ps


module tb_mem_storage_module(

    );
    
    parameter NUM_INSTRUCTIONS = 40;
    
    //instruction inputs
    reg [31:0] dest [NUM_INSTRUCTIONS];
    reg [4:0] r1 [NUM_INSTRUCTIONS];
    reg [4:0] r2 [NUM_INSTRUCTIONS];
    reg [31:0] cycles_to_write [NUM_INSTRUCTIONS];
    reg if_valid [NUM_INSTRUCTIONS];
    reg if_add [NUM_INSTRUCTIONS];
    
    //expected outputs for each instruction, should be in order
    reg [4:0] commit_address [NUM_INSTRUCTIONS];
    reg [31:0] commit_data [NUM_INSTRUCTIONS];
    reg commit_valid [NUM_INSTRUCTIONS];
    
    //initial values for rf and expected final values
    reg [31:0] initial_rf [32];
    reg [31:0] final_rf [32];
    
    initial begin
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\dest.txt", dest, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\r1.txt", r1, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\r2.txt", r2, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\cycles_to_write.txt", cycles_to_write, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\if_valid.txt", if_valid, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\if_add.txt", if_add, 0, NUM_INSTRUCTIONS - 1);
                                                                           
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\commit_address.txt", commit_address, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\commit_data.txt", commit_data, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\commit_valid.txt", commit_valid, 0, NUM_INSTRUCTIONS - 1);
                                                                           
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\starting_data.txt", initial_rf, 0, 32 - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\final_reg_file.txt", final_rf, 0, 32 - 1);
        
    end
endmodule
