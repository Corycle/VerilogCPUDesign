module CPU_Pipeline;
    reg CLK;

    MCU MCU(.ID_OPCode(ID_IR.Q[31:26]),
            .EX_OPCode(EX_IR.Q[31:26]),
            .MA_OPCode(MA_IR.Q[31:26]),
            .WB_OPCode(WB_IR.Q[31:26]),
            .WB_Func(WB_IR.Q[5:0]));

    //FI
    PC PC(.CLK(CLK),.D(MUX1.Out));
    Add Add1(.A(PC.Q),.B(4));
    MUX32_2 MUX1(.In0(Add1.C),.In1(MUX3.Out),.Ctrl((MA_Flag.Q[0]&MCU.Branch)|MCU.Jump));
    IM IM(.Addr(PC.Q));

    //ID
    Reg ID_NPC1(.CLK(CLK),.Ctrl(1),.D(Add1.C));
    Reg ID_IR(.CLK(CLK),.Ctrl(1),.D(IM.Inst));
    RF RF(.CLK(CLK),.W(MCU.RegWr),.R_reg1(ID_IR.Q[25:21]),.R_reg2(ID_IR.Q[20:16]),.W_reg(MUX5.Out),.W_data(MUX4.Out));
    SigExt SigExt(.In(ID_IR.Q[15:0]));

    //EX
    Reg EX_NPC1(.CLK(CLK),.Ctrl(1),.D(ID_NPC1.Q));
    Reg EX_Rs(.CLK(CLK),.Ctrl(1),.D(RF.R_data1));
    Reg EX_Rt(.CLK(CLK),.Ctrl(1),.D(RF.R_data2));
    Reg EX_Imm32(.CLK(CLK),.Ctrl(1),.D(SigExt.Out));
    Reg EX_IR(.CLK(CLK),.Ctrl(1),.D(ID_IR.Q));
    Add Add2(.A(EX_NPC1.Q),.B({EX_Imm32.Q[29:0],2'b0}));
    MUX32_2 MUX2(.In0(EX_Rt.Q),.In1(EX_Imm32.Q),.Ctrl(MCU.ALUSrc));
    ALUCU ALUCU(.ALUOP(MCU.ALUOP),.Func(EX_IR.Q[5:0]));
    ALU ALU(.A(EX_Rs.Q),.B(MUX2.Out),.ALUCtrl(ALUCU.ALUCtrl));

    //MA
    Reg MA_NPC1(.CLK(CLK),.Ctrl(1),.D(EX_NPC1.Q));
    Reg MA_NPC2(.CLK(CLK),.Ctrl(1),.D(Add2.C));
    Reg MA_NPC3(.CLK(CLK),.Ctrl(1),.D({EX_NPC1.Q[31:28],EX_IR.Q[25:0],2'b0}));
    Reg MA_Flag(.CLK(CLK),.Ctrl(1),.D(ALU.ZF));
    Reg MA_ALUOut(.CLK(CLK),.Ctrl(1),.D(ALU.C));
    Reg MA_Rt(.CLK(CLK),.Ctrl(1),.D(EX_Rt.Q));
    Reg MA_IR(.CLK(CLK),.Ctrl(1),.D(EX_IR.Q));
    MUX32_4 MUX3(.In0(MA_NPC1.Q),.In1(MA_NPC3.Q),.In2(MA_NPC2.Q),.In3(0),.Ctrl({MA_Flag.Q[0]&MCU.Branch,MCU.Jump}));
    DM DM(.R(MCU.MemRd),.W(MCU.MemWr),.Addr(MA_ALUOut.Q),.W_data(MA_Rt.Q));

    //WB
    Reg WB_ALUOut(.CLK(CLK),.Ctrl(1),.D(MA_ALUOut.Q));
    Reg WB_MEMOut(.CLK(CLK),.Ctrl(1),.D(DM.R_data));
    Reg WB_IR(.CLK(CLK),.Ctrl(1),.D(MA_IR.Q));
    MUX32_2 MUX4(.In0(WB_ALUOut.Q),.In1(WB_MEMOut.Q),.Ctrl(MCU.MemtoReg));
    MUX5_2 MUX5(.In0(WB_IR.Q[20:16]),.In1(WB_IR.Q[15:11]),.Ctrl(MCU.RegDst));

    initial begin
        CLK=0;
    end
    always begin
        #1;
        CLK=~CLK;
    end
endmodule