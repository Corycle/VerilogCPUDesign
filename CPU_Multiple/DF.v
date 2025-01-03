module DF(
	input CLK,
	input [31:0] In,
	output reg [31:0] Out
);
	always @ (posedge CLK) begin
		Out=In;
	end
endmodule