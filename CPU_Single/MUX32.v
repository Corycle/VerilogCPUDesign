module MUX32(
	input [31:0] In0,
	input [31:0] In1,
	output [31:0] Out,
	input Ctrl
);
	assign Out=Ctrl?In1:In0;
endmodule