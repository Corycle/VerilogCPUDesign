module MCU(
    input [5:0] OPCode,
    output reg Branch,
    output reg MemtoReg,
    output reg [1:0] ALUOP,
    output reg MemWr,
    output reg MemRd,
    output reg ALUSrc,
    output reg RegDst,
    output reg Jump,
    output reg RegWr
);
    always @(*) begin
        case(OPCode)
        6'b000000://add & addu & sub & and & or & slt
        begin
            RegDst=1;
            ALUSrc=0;
            RegWr=1;
            MemtoReg=0;
            MemRd=0;
            MemWr=0;
            Branch=0;
            Jump=0;
            ALUOP=2'b00;
        end
        6'b100011://lw
        begin
            RegDst=0;
            ALUSrc=1;
            RegWr=1;
            MemtoReg=1;
            MemRd=1;
            MemWr=0;
            Branch=0;
            Jump=0;
            ALUOP=2'b01;
        end
        6'b101011://sw
        begin
            RegDst=0;
            ALUSrc=1;
            RegWr=0;
            MemtoReg=0;
            MemRd=0;
            MemWr=1;
            Branch=0;
            Jump=0;
            ALUOP=2'b01;
        end
        6'b000100://beq
        begin
            RegDst=0;
            ALUSrc=0;
            RegWr=0;
            MemtoReg=0;
            MemRd=0;
            MemWr=0;
            Branch=1;
            Jump=0;
            ALUOP=2'b10;
        end
        6'b000010://j
        begin
            RegDst=0;
            ALUSrc=0;
            RegWr=0;
            MemtoReg=0;
            MemRd=0;
            MemWr=0;
            Branch=0;
            Jump=1;
            ALUOP=2'b11;
        end
        endcase
    end
endmodule