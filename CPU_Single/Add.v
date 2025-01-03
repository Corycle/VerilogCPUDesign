module Add(
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] C
);
    always @(A,B) begin
        C=A+B;
    end
endmodule