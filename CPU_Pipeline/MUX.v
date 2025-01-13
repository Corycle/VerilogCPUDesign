module MUX5_2(
	input [4:0] In0,
	input [4:0] In1,
	input Ctrl,
	output [4:0] Out
);
    assign Out=Ctrl?In1:In0;
endmodule

module MUX32_2(
	input [31:0] In0,
	input [31:0] In1,
	input Ctrl,
	output [31:0] Out
);
    assign Out=Ctrl?In1:In0;
endmodule

module MUX32_4(
	input [31:0] In0,
	input [31:0] In1,
	input [31:0] In2,
	input [31:0] In3,
	input [1:0] Ctrl,
	output [31:0] Out
);
	assign Out=Ctrl[1]?Ctrl[0]?In3:In2:Ctrl[0]?In1:In0;
endmodule