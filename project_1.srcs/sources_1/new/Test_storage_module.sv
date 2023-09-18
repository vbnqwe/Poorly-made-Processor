`timescale 1ns / 1ps


module Test_storage_module(
    );
    
    parameter NUM_INSTRUCTIONS = 40;
    
    //test variables - inputs
    reg [31:0] dest_t [NUM_INSTRUCTIONS];
    reg [31:0] r1_t [NUM_INSTRUCTIONS];
    reg [31:0] r2_t [NUM_INSTRUCTIONS];
    reg [31:0] return_data_t [NUM_INSTRUCTIONS];
    reg [31:0] num_cycles_t [NUM_INSTRUCTIONS];
    
     
    //test variables - values to compare to
    reg [31:0] r1_c [NUM_INSTRUCTIONS];
    reg [31:0] r2_c [NUM_INSTRUCTIONS];
    reg [31:0] rf_c [32];
    
    
    
    
    initial begin
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\r1.txt", r1_t, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\r2.txt", r2_t, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\dest.txt", dest_t, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\instruction_data.txt", return_data_t, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\instruction_cycles.txt", num_cycles_t, 0, NUM_INSTRUCTIONS - 1);
        //load corrC:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\s
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\r1_out.txt", r1_c, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\r2_out.txt", r2_c, 0, NUM_INSTRUCTIONS - 1);
        $readmemb("C:\\Users\\vbogd\\Documents\\Superscalar-Risc-V\\project_1.srcs\\resources\\reg_file_out.txt", rf_c, 0, 31);
    end
endmodule
