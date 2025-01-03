module MM(
	input [1:0] Ctrl,
	input [31:0] Addr,
	input [31:0] W_data,
	output reg [31:0] R_data
);
	reg [7:0] Mem [1023:0];
	initial begin
		Mem[0]=8'b10001100;Mem[1]=8'b01000000;Mem[2]=8'b00000000;Mem[3]=8'b00100000;//lw R0 32(R2)
		Mem[4]=8'b10001100;Mem[5]=8'b01000001;Mem[6]=8'b00000000;Mem[7]=8'b00100100;//lw R1 36(R2)
		Mem[8]=8'b00000000;Mem[9]=8'b00100000;Mem[10]=8'b00010000;Mem[11]=8'b00000001;//sub R2 R1 R0
		Mem[12]=8'b00000000;Mem[13]=8'b00000001;Mem[14]=8'b00011000;Mem[15]=8'b00001001;//or R3 R0 R1
		Mem[16]=8'b00000000;Mem[17]=8'b01000011;Mem[18]=8'b00100000;Mem[19]=8'b00001110;//slt R4 R2 R3
		Mem[20]=8'b00010000;Mem[21]=8'b00000010;Mem[22]=8'b00000000;Mem[23]=8'b00000001;//beq R0 R2 1
		Mem[24]=8'b00000000;Mem[25]=8'b00000001;Mem[26]=8'b00011000;Mem[27]=8'b00001001;//or R3 R0 R1
		Mem[28]=8'b00001000;Mem[29]=8'b00000000;Mem[30]=8'b00000000;Mem[31]=8'b00000000;//j 0
		Mem[32]=8'b00000000;Mem[33]=8'b00000000;Mem[34]=8'b00000000;Mem[35]=8'b00000101;//32:5
		Mem[36]=8'b00000000;Mem[37]=8'b00000000;Mem[38]=8'b00000000;Mem[39]=8'b00001010;//36:10
	end
	
	always @ (*) begin
		case(Ctrl)
			2'b10: 
                R_data={Mem[Addr[9:0]],Mem[Addr[9:0]+1],Mem[Addr[9:0]+2],Mem[Addr[9:0]+3]};
			2'b01: 
                Mem[Addr[9:0]]=W_data[7:0];
			default:
                R_data=32'b0;
		endcase
	end
endmodule