module SigExt(
	input [15:0] In,
	output reg [31:0] Out
);
	always @ (*) begin
		Out={{(16){In[15]}},In[15:0]};
	end
endmodule