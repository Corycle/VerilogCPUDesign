module MCU(
    input [5:0] ID_OPCode,
    input [5:0] EX_OPCode,
    input [5:0] MA_OPCode,
    input [5:0] WB_OPCode,
    input [5:0] WB_Func,
    output reg RegWr,
    output reg ALUSrc,
    output reg [1:0] ALUOP,
    output reg Jump,
    output reg Branch,
    output reg MemRd,
    output reg MemWr,
    output reg MemtoReg,
    output reg RegDst
);
    // always @(ID_OPCode) begin
    //     case(ID_OPCode)
    
    //     endcase
    // end

    always @(EX_OPCode) begin
        case(EX_OPCode)
            6'b000000://add & addu & sub & subu & and & or & xor & slt
            begin
                ALUSrc=0;
                ALUOP=2'b00;
            end
            6'b100011://lw
            begin
                ALUSrc=1;
                ALUOP=2'b01;
            end
            6'b101011://sw
            begin
                ALUSrc=1;
                ALUOP=2'b01;
            end
            6'b000100://beq
            begin
                ALUSrc=0;
                ALUOP=2'b10;
            end
            6'b000010://j
            begin
                ALUSrc=0;
                ALUOP=2'b11;
            end
        endcase
    end

    always @(MA_OPCode) begin
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
            end
            6'b000100://beq
            begin
                MemRd=0;
                MemWr=0;
                Branch=1;
                Jump=0;
            end
            6'b000010://j
            begin
                MemRd=0;
                MemWr=0;
                Branch=0;
                Jump=1;
            end
        endcase
    end

    always @(WB_OPCode) begin
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
    end
endmodule