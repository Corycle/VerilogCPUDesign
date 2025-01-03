module Reg(
    input CLK,
    input [31:0] D,
    output reg [31:0] Q,
    input Ctrl
);
    always @(posedge CLK) begin
        if(Ctrl) Q=D;
    end
endmodule