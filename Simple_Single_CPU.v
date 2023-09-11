//0713216

//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
//PC
wire [31:0] PC_out;
wire [31:0] PC_in;

//Adder1
wire [31:0] next_PC;

//Instruction_memory
wire [31:0] instruction;

//MUX1 (size5)
wire [4:0] Write_Reg;

//Register_File
wire [31:0] RS_data;
wire [31:0] RT_data;

//Decoder
wire Branch;
wire MenToReg;
wire Jump;
wire MemRead;
wire MemWrite;
wire [2:0] ALUOp;
wire ALUSrc;
wire RegWrite;
wire RegDst;
wire Jr;

//ALU_control
wire [3:0] ALU_control_output;

//sign_extension
wire [31:0] sign_extension_output;

//MUX2 (size32)
wire [31:0] MUX2_output;

//ALU
wire [31:0] ALU_result;
wire Zero;

//Adder2
wire [31:0] Target_address;

//Shifter1
wire [31:0] shifter1_output;

//Shifter2
wire [31:0] shifter2_output;

//MUX3
wire [31:0] MUX3_output;

//Data Memory
wire [31:0] Data_Memory_output;

//MUX5
wire [31:0] MUX5_output;

//MUX6
wire [31:0] MUX6_output;

//MUX7
wire [31:0] MUX7_output;

//MUX8
wire [31:0] MUX8_output;

wire [31:0] Jump_address;

//Shifter1
assign Jump_address[1:0] = 2'b00;
assign Jump_address[28-1:2] = instruction[26-1:0];
assign Jump_address[32-1:28] = next_PC[32-1:28];

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(MUX6_output) ,   //32 bits
	    .pc_out_o(PC_out)    // 32 bits
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(PC_out),     
	    .sum_o(next_PC)    
	    );
	             
Instr_Memory IM(
        .pc_addr_i(PC_out),  
	    .instr_o(instruction)    
	    );
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) , 
	   // .return_addr(next_PC),
	    //.instruction(instruction[31:26]),   
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(MUX7_output) ,  
        .RDdata_i(MUX8_output)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RS_data) ,  
        .RTdata_o(RT_data)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
        .function_i(instruction[5:0]),
        .Branch_o(Branch),
        .MemtoReg_o(MemToReg),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),
	    .Jr_o(Jr)
	    );

ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALU_control_output) 
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(sign_extension_output)
        );
		
ALU  ALU(
         .src1_i(RS_data),
         .src2_i(MUX2_output),
         .ctrl_i(ALU_control_output),
         .result_o(ALU_result),
         .zero_o(Zero)
         );
		
Adder Adder2(
        .src1_i(next_PC),     
	    .src2_i(shifter2_output),     
	    .sum_o(Target_address)      
	    );
		
Shift_Left_Two_32 #(.size(32))  Shifter2(
        .data_i(sign_extension_output),
        .data_o(shifter2_output)
        ); 		 

Data_Memory Data_Memory(
        .clk_i(clk_i), 
        .addr_i(ALU_result),
        .data_i(RT_data),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(Data_Memory_output)
        );

MUX_2to1 #(.size(5)) MUX1(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(RegDst),
        .data_o(Write_Reg)
        );	
        
MUX_2to1 #(.size(32)) MUX2(
        .data0_i(RT_data),
        .data1_i(sign_extension_output),
        .select_i(ALUSrc),
        .data_o(MUX2_output)
        );	

MUX_2to1 #(.size(32)) MUX3(
        .data0_i(next_PC),
        .data1_i(Target_address),
        .select_i(Branch & Zero),
        .data_o(MUX3_output)
        );	
        
MUX_2to1 #(.size(32)) MUX4(
        .data0_i(MUX3_output),
        .data1_i(Jump_address),
        .select_i(Jump),
        .data_o(PC_in)
         );   
         
 MUX_2to1 #(.size(32)) MUX5(
        .data0_i(ALU_result),
        .data1_i(Data_Memory_output),
        .select_i(MemToReg),
        .data_o(MUX5_output)
         );   
       
 MUX_2to1 #(.size(32)) MUX6(
        .data0_i(PC_in),
        .data1_i(RS_data),
        .select_i(Jr),
        .data_o(MUX6_output)
         ); 
         
 MUX_2to1 #(.size(32)) MUX7(
        .data0_i(Write_Reg),
        .data1_i(ALU_result[4:0]),
        .select_i(Jump),
        .data_o(MUX7_output)
         ); 
         
MUX_2to1 #(.size(32)) MUX8(
        .data0_i(MUX5_output),
        .data1_i(next_PC),
        .select_i(Jump),
        .data_o(MUX8_output)
         ); 
        
endmodule