module MUX5_2(
	input [4:0] In0,
	input [4:0] In1,
	input Ctrl,
	output reg [4:0] Out
);
	always @ (*) begin
		Out=Ctrl?In1:In0;
	end
endmodule

module MUX32_2(
	input [31:0] In0,
	input [31:0] In1,
	input Ctrl,
	output reg [31:0] Out
);
	always @ (*) begin
		Out=Ctrl?In1:In0;
	end
endmodule

module MUX32_4(
	input [31:0] In0,
	input [31:0] In1,
	input [31:0] In2,
	input [31:0] In3,
	input [1:0] Ctrl,
	output reg [31:0] Out
);
	always @ (*) begin
		case(Ctrl)
			2'b00: 
                Out=In0;
			2'b01: 
                Out=In1;
			2'b10: 
                Out=In2;
			2'b11: 
                Out=In3;
		endcase
	end
endmodule