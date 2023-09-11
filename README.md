# CO-Lab3-Single-Cycle-CPU-Complete-Edition

## Goal
Based on Lab 2, you need to add a memory unit and implement a complete single cycle CPU 
that can run R-type, I-type and jump instructions. 

## Lab Requirement
1. REGISTER_BANK [29] represents the stack pointer register value (initially 128). Other 
registers are initialized to 0.
2. You may add more control signals to the decoder:  
  i. Branch_o  
  ii. Jump_o  
  iii. MemRead_o  
  iv. MemWrite_o  
  v. MemtoReg_o
3. Basic Instructions: the following instructions have to be executed correctly in
your CPU design, and we may use some hidden cases to further evaluate your
design
(For those who can't read testcase txt files after adding the testcase into simulation
sources, please change the relative path in instr_memory file to absolute path.)
Your CPU design has to support the instruction set from Lab 2 + the following
instructions:  
![image](https://github.com/YHK00103/CO-Lab3-Single-Cycle-CPU-Complete-Edition/assets/117156581/1d0b00c3-22ca-48ed-945c-7be63b4e3f7e)
4. Advanced Instructions: the following instructions have to be executed correctly
in your CPU design, and we may use some hidden cases to further evaluate 
your design
![image](https://github.com/YHK00103/CO-Lab3-Single-Cycle-CPU-Complete-Edition/assets/117156581/ff8ba2c9-6e5e-4bf0-a277-8d22fdc9a7b0)

## Architecture Diagram
![Lab3_single_cycle_CPU_不更改reg](https://github.com/YHK00103/CO-Lab3-Single-Cycle-CPU-Complete-Edition/assets/117156581/d2f9e404-bfc1-42fa-a74e-e21013bebcb3)

