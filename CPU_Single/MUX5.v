module MUX5(
	input [4:0] In0,
	input [4:0] In1,
	output [4:0] Out,
	input Ctrl
);
	assign Out=Ctrl?In1:In0;
endmodule