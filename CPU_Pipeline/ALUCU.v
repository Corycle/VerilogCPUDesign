module ALUCU(
    input [1:0] ALUOP,
    input [5:0] Func,
    output reg [2:0] ALUCtrl
);
    always @(ALUOP,Func) begin
        case(ALUOP)
            2'b00:
            begin
                case(Func)
                    6'b100000://add
                        ALUCtrl=3'b010;
                    6'b100001://addu
                        ALUCtrl=3'b101;
                    6'b100010://sub
                        ALUCtrl=3'b011;
                    6'b100011://subu
                        ALUCtrl=3'b110;
                    6'b100100://and
                        ALUCtrl=3'b000;
                    6'b100101://or
                        ALUCtrl=3'b001;
                    6'b100110://xor
                        ALUCtrl=3'b111;
                    6'b101010://slt
                        ALUCtrl=3'b100;
                endcase
            end
            2'b01:
                ALUCtrl=3'b101;
            2'b10:
                ALUCtrl=3'b011;
        endcase
    end
endmodule