module MCU(
	input CLK,
	input [5:0] OPCode,
	output reg [17:0] Ctrl
);
	reg [3:0] Sta;
	initial begin
        Sta=4'd0;
    end
	always @ (negedge CLK) begin
		case(Sta)
			4'd0:
                Sta=4'd1;
			4'd1://DECODE
            begin
				case(OPCode)
					6'b000000://R
                        Sta=4'd2;
                    6'b100011://lw
                        Sta=4'd2;
                    6'b101011://sw
                        Sta=4'd2;
					6'b000100://beq
                        Sta=4'd5;
					6'b000010://j
                        Sta=4'd11;
				endcase
			end
			4'd2://LOAD/STORE/R
            begin
				case(OPCode)
					6'b000000://R
                        Sta=4'd3;
					6'b100011://lw
                        Sta=4'd7;
                    6'b101011://sw
                        Sta=4'd7;
				endcase
			end
			4'd3://ALU1
                Sta=4'd4;
            4'd4://ALU2
                Sta=4'd1;
			4'd5://BEQ1
                Sta=4'd6;
            4'd6://BEQ2
                Sta=4'd1;
			4'd7://LOAD1/STORE1
            begin
                case(OPCode)
					6'b100011://lw
                        Sta=4'd8;
                    6'b101011://sw
                        Sta=4'd10;
				endcase
			end
			4'd8://LOAD2
                Sta=4'd9;
            4'd9://LOAD3
                Sta=4'd1;
            4'd10://STORE2
                Sta=4'd1;
            4'd11://JUMP
                Sta=4'd1;
		endcase
		case(Sta)
			4'd1://IR=M[PC],PC=PC+4
                Ctrl=18'b010000000010100010;
			4'd2://A=R_data1,B=R_data2
                Ctrl=18'b000000000000000000;
			4'd3://ALUOut=ALU
                Ctrl=18'b000000010000001000;
			4'd4://Reg[W_Reg]=W_data
                Ctrl=18'b100001000000000000;
			4'd5://A=R_data1,B=R_data2,ALUOut=PC+SignedAddress*4
                Ctrl=18'b000000000000000110;
			4'd6://PC=ALUOut
                Ctrl=18'b000010001000011000;
			4'd7://ALUOut=ALU
                Ctrl=18'b000000000000001100;
			4'd8://MDR=M[ALUOut]
                Ctrl=18'b010000000001000000;
			4'd9://Rt=MDR
                Ctrl=18'b100000100000000000;
			4'd10://M[ALUOut]=B
                Ctrl=18'b001000000001000000;
			4'd11://PC=PC[31:28]|(Inst[25:0]<<2)
                Ctrl=18'b000100000000100000;
		endcase
	end
endmodule