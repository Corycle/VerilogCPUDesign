module ALU(
	input [31:0] A,
	input [31:0] B,
	input [5:0] ALUCtrl,
	output reg [31:0] C,
	output reg ZF,
	output reg OF
);
    reg [63:0] tmp;
	always @ (*) begin
		case (ALUCtrl)
			6'b000100://ADD
            begin
				tmp=$signed(A)+$signed(B);
                C=tmp[31:0];
                OF=(tmp[32]!=tmp[31]);
			end
			6'b000101://SUB
            begin
				tmp=$signed(A)-$signed(B);
                C=tmp[31:0];
                OF=(tmp[32]!=tmp[31]);
			end
			6'b000000://ADDU
            begin
                tmp={32'b0,A}+{32'b0,B};
                C=tmp[31:0];
                OF=tmp[32];
            end
			6'b000001://SUBU
            begin
                tmp={32'b0,A}-{32'b0,B};
                C=tmp[31:0];
                OF=tmp[32];
            end
			6'b001110://SLT
                C=($signed(A)<$signed(B));
            6'b001100://A==B
                C=(A==B);
			6'b001000://AND
                C=(A&B);
			6'b001001://OR
                C=(A|B);
            6'b001010://NOT
                C=(~A);
            6'b001011://XOR
                C=(A^B);
			6'b111111://NULL
                C=0;
		endcase
        ZF=(C==0);
	end
endmodule