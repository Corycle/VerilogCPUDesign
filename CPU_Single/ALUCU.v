module ALUCU(
    input reg [1:0] ALUOP,
    input reg [5:0] Func,
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
                    6'b100100://and
                        ALUCtrl=3'b000;
                    6'b100101://or
                        ALUCtrl=3'b001;
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