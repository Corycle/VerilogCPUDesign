module MCU(
    input CLK,
    input [31:0] ID_IR,
    input [31:0] EX_IR,
    input [31:0] MA_IR,
    input [31:0] WB_IR,
    input MA_Flag,
    output reg RegWr,
    output reg [1:0] ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] ALUOP,
    output reg Jump,
    output reg Branch,
    output reg MemRd,
    output reg MemWr,
    output reg MemtoReg,
    output reg RegDst,
    output reg MemSrc
);
    integer rst;
    reg [5:0] ID_OPCode;
    reg [5:0] EX_OPCode;
    reg [5:0] MA_OPCode;
    reg [5:0] WB_OPCode;
    reg [5:0] MA_Func;
    reg [5:0] WB_Func;

    initial begin
        rst=0;
    end

    always @(*) begin
        ID_OPCode=ID_IR[31:26];
        EX_OPCode=EX_IR[31:26];
        MA_OPCode=MA_IR[31:26];
        WB_OPCode=WB_IR[31:26];
        MA_Func=MA_IR[5:0];
        WB_Func=WB_IR[5:0];
        
        //EX
        ALUSrcA=2'b00;
        case(EX_OPCode)
            6'b000000://add & addu & sub & subu & and & or & xor & slt & nop
            begin
                ALUSrcB=2'b00;
                // sw & R-R
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==EX_IR[25:21])ALUSrcA=2'b10;
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==EX_IR[20:16])ALUSrcB=2'b10;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b10;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==EX_IR[20:16])ALUSrcB=2'b10;
                if(MA_OPCode==6'b000000&&MA_Func&&MA_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b01;
                if(MA_OPCode==6'b000000&&MA_Func&&MA_IR[15:11]==EX_IR[20:16])ALUSrcB=2'b01;
                ALUOP=2'b00;
            end
            6'b100011://lw
            begin
                ALUSrcB=2'b11;
                // sw & R-R
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==EX_IR[25:21])ALUSrcA=2'b10;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b10;
                if(MA_OPCode==6'b000000&&MA_Func&&MA_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b01;
                ALUOP=2'b01;
            end
            6'b101011://sw
            begin
                ALUSrcB=2'b11;
                // sw & R-R
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==EX_IR[25:21])ALUSrcA=2'b10;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b10;
                if(MA_OPCode==6'b000000&&MA_Func&&MA_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b01;
                ALUOP=2'b01;
            end
            6'b000100://beq
            begin
                ALUSrcB=2'b00;
                // sw & R-R
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==EX_IR[25:21])ALUSrcA=2'b10;
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==EX_IR[20:16])ALUSrcB=2'b10;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b10;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==EX_IR[20:16])ALUSrcB=2'b10;
                if(MA_OPCode==6'b000000&&MA_Func&&MA_IR[15:11]==EX_IR[25:21])ALUSrcA=2'b01;
                if(MA_OPCode==6'b000000&&MA_Func&&MA_IR[15:11]==EX_IR[20:16])ALUSrcB=2'b01;
                ALUOP=2'b10;
            end
            6'b000010://j
            begin
                ALUSrcB=2'b00;
                ALUOP=2'b11;
            end
        endcase
        
        //MA
        MemSrc=0;
        case(MA_OPCode)
            6'b000000://add & addu & sub & subu & and & or & xor & slt
            begin
                MemRd=0;
                MemWr=0;
                Branch=0;
                Jump=0;
            end
            6'b100011://lw
            begin
                MemRd=1;
                MemWr=0;
                Branch=0;
                Jump=0;
            end
            6'b101011://sw
            begin
                MemRd=0;
                MemWr=1;
                Branch=0;
                Jump=0;
                if(WB_OPCode==6'b101011&&WB_IR[20:16]==MA_IR[20:16])MemSrc=1;
                if(WB_OPCode==6'b000000&&WB_Func&&WB_IR[15:11]==MA_IR[20:16])MemSrc=1;
            end
            6'b000100://beq
            begin
                MemRd=0;
                MemWr=0;
                if(rst) Branch=0;
                else Branch=1;
                Jump=0;
            end
            6'b000010://j
            begin
                MemRd=0;
                MemWr=0;
                Branch=0;
                if(rst) Jump=0;
                else Jump=1;
            end
        endcase
        
        //WB
        case(WB_OPCode)
            6'b000000://add & addu & sub & subu & and & or & xor & slt
            begin
                if(WB_Func)RegWr=1;
                else RegWr=0;
                RegDst=1;
                MemtoReg=0;
            end
            6'b100011://lw
            begin
                RegDst=0;
                RegWr=1;
                MemtoReg=1;
            end
            6'b101011://sw
            begin
                RegDst=0;
                RegWr=0;
                MemtoReg=0;
            end
            6'b000100://beq
            begin
                RegDst=0;
                RegWr=0;
                MemtoReg=0;
            end
            6'b000010://j
            begin
                RegDst=0;
                RegWr=0;
                MemtoReg=0;
            end
        endcase

        if(rst) begin
            MemWr=0;
            RegWr=0;
        end

        if((MA_Flag&Branch)|Jump) begin
            rst=3;
        end
    end

    always @(posedge CLK) begin
        if(rst>0) rst=rst-1;
    end
endmodule