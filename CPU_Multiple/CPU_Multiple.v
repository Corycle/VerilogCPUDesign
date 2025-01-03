module CPU_Multiple;
	reg CLK;
	wire [31:0] Data_reg1_out,Data_reg2_out,ALU_A,ALU_B,Inst,S_Addr,ALUOut1,ALUOut2;
	wire [31:0] Addr,MMOut,MDR_out,PC_in,PC_out,Data_out1,Data_out2,Data_in;
	wire [17:0] MCUCtrl;
	wire [5:0] ALUCtrl;
	wire [4:0] Addr_in;

	MCU MCU(.CLK(CLK),.OPCode(Inst[31:26]),.Ctrl(MCUCtrl));
	IR IR(.CLK(CLK),.In(MMOut),.W(MCUCtrl[7]),.Out(Inst));
	PC PC(.CLK(CLK),.W(MCUCtrl[5]||(MCUCtrl[4]&&ALUOut1[0])),.In(PC_in),.Out(PC_out));
	ALU ALU(.A(ALU_A),.B(ALU_B),.ALUCtrl(ALUCtrl),.C(ALUOut1));
    RF RF(.CLK(CLK),.R_reg1(Inst[25:21]),.R_reg2(Inst[20:16]),.W_reg(Addr_in),.W_data(Data_in),.W(MCUCtrl[17]),.R_data1(Data_out1),.R_data2(Data_out2));
	MM MM(.Addr(Addr),.W_data(Data_reg2_out),.Ctrl(MCUCtrl[16:15]),.R_data(MMOut));
	DF RF_R_data1(.CLK(CLK),.In(Data_out1),.Out(Data_reg1_out));
	DF RF_R_data2(.CLK(CLK),.In(Data_out2),.Out(Data_reg2_out));
	DF ALUOut(.CLK(CLK),.In(ALUOut1),.Out(ALUOut2));
	DF MDR(.CLK(CLK),.In(MMOut),.Out(MDR_out));
	SigExt SigExt(.In(Inst[15:0]),.Out(S_Addr));
	MUX5_2 MUX1(.In0(Inst[20:16]),.In1(Inst[15:11]),.Ctrl(MCUCtrl[12]),.Out(Addr_in));
	MUX32_2 MUX2(.In0(ALUOut2),.In1(MDR_out),.Ctrl(MCUCtrl[11]),.Out(Data_in));
	MUX32_2 MUX3(.In0(PC_out),.In1(Data_reg1_out),.Ctrl(MCUCtrl[3]),.Out(ALU_A));
	MUX32_4 MUX4(.In0(Data_reg2_out),.In1(32'h00000004),.In2(S_Addr),.In3({S_Addr[29:0],2'b00}),.Ctrl(MCUCtrl[2:1]),.Out(ALU_B));
	MUX32_4 MUX5(.In0(ALUOut1),.In1(ALUOut2),.In2({PC_out[31:28],Inst[25:0],2'b00}),.In3(32'hffffffff),.Ctrl(MCUCtrl[14:13]),.Out(PC_in));
	MUX32_2 MUX6(.In0(PC_out),.In1(ALUOut2),.Ctrl(MCUCtrl[6]),.Out(Addr));
	ALUCU ALUCU(.OPCode(Inst[5:0]),.Ctrl(MCUCtrl[10:9]),.ALUCtrl(ALUCtrl));

	initial begin
		CLK=1;
	end
	always begin
		#1;
		CLK=~CLK;
	end
endmodule