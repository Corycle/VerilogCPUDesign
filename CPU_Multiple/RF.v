module RF(
	input W,
	input CLK,
	input [4:0] R_reg1,
	input [4:0] R_reg2,
	input [4:0] W_reg,
	input [31:0] W_data,
	output reg [31:0] R_data1,
	output reg [31:0] R_data2
);
	integer i;
	reg [31:0] Mem [31:0];
	initial begin
		for(i=0;i<32;i=i+1)Mem[i]=0;
	end
	always @ (*) begin
		R_data1<=Mem[R_reg1];
		R_data2<=Mem[R_reg2];
	end
	always @ (posedge CLK) begin
		if(W) Mem[W_reg]=W_data;
	end
endmodule