module PC(
	input W,
	input CLK,
	input [31:0] In,
	output reg [31:0] Out
);
	initial begin
		Out=0;
	end
	always @ (posedge CLK) begin
		if(W) Out=In;
	end
endmodule