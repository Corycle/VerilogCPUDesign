module ALU(
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] C,
    input [2:0] ALUCtrl,
    output reg ZF,
    output reg OF
);
    reg [63:0] tmp;
    always @(*) begin
        case(ALUCtrl)
            3'b000://AND
                C=A&B;
            3'b001://OR
                C=A|B;
            3'b111://XOR
                C=A^B;
            3'b010://ADD
            begin
				tmp=$signed(A)+$signed(B);
                C=tmp[31:0];
                OF=(tmp[32]!=tmp[31]);
            end
            3'b011://SUB
            begin
				tmp=$signed(A)-$signed(B);
                C=tmp[31:0];
                OF=(tmp[32]!=tmp[31]);
            end
            3'b101://ADDU
            begin
                tmp={32'b0,A}+{32'b0,B};
                C=tmp[31:0];
                OF=tmp[32];
            end
            3'b110://SUBU
            begin
                tmp={32'b0,A}-{32'b0,B};
                C=tmp[31:0];
                OF=tmp[32];
            end
            3'b100://SLT
                C=$signed(A)<$signed(B);
        endcase
        ZF=(C==0);
    end
endmodule
