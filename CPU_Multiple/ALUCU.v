module ALUCU(
	input [1:0] Ctrl,
	input [5:0] OPCode,
	output reg [5:0] ALUCtrl
);
	always @ (*) begin
		case(Ctrl)
			2'b10://R
                ALUCtrl=OPCode;
			2'b01://BEQ1
                ALUCtrl=6'b001100;
			2'b00://LW,SW,BEQ2
                ALUCtrl=6'b000000;
			default://null
                ALUCtrl=6'b111111;
		endcase
	end
endmodule