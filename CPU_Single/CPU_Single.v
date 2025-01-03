module CPU_Single;
    reg CLK;

    IM IM(.Addr(PC.Q));
    PC PC(.CLK(CLK),.D(MUX2.Out));
    MCU MCU(.OPCode(IM.Inst[31:26]));
    Add Add1(.A(4),.B(PC.Q));
    Add Add2(.A(Add1.C),.B({{(14){IM.Inst[15]}},IM.Inst[15:0],2'b0}));
    MUX32 MUX1(.In0(Add1.C),.In1(Add2.C),.Ctrl(MCU.Branch&ALU.ZF));
    MUX32 MUX2(.In0(MUX1.Out),.In1({Add1.C[31:28],IM.Inst[25:0],2'b0}),.Ctrl(MCU.Jump));
    MUX5 MUX3(.In0(IM.Inst[20:16]),.In1(IM.Inst[15:11]),.Ctrl(MCU.RegDst));
    RF RF(.CLK(CLK),.R_reg1(IM.Inst[25:21]),.R_reg2(IM.Inst[20:16]),.W_reg(MUX3.Out),.W(MCU.RegWr),.W_data(MUX5.Out));
    MUX32 MUX4(.In0(RF.R_data2),.In1({{(16){IM.Inst[15]}},IM.Inst[15:0]}),.Ctrl(MCU.ALUSrc));
    ALUCU ALUCU(.ALUOP(MCU.ALUOP),.Func(IM.Inst[5:0]));
    ALU ALU(.A(RF.R_data1),.B(MUX4.Out),.ALUCtrl(ALUCU.ALUCtrl),.ZF(ZLU_ZF));
    DM DM(.Addr(ALU.C),.W_data(RF.R_data2),.R(MCU.MemRd),.W(MCU.MemWr));
    MUX32 MUX5(.In0(ALU.C),.In1(DM.R_data),.Ctrl(MCU.MemtoReg));

    initial begin
        CLK=0;
    end
    always begin
        #1;
        CLK=~CLK;
    end
endmodule