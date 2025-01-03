module IR(
	input W,
	input CLK,
	input [31:0] In,
	output reg [31:0] Out
);
	always @ (posedge CLK) begin
		if(W) Out=In;
	end
endmodule