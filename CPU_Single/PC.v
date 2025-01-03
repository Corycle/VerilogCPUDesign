module PC(
    input CLK,
    input [31:0] D,
    output reg [31:0] Q
);
    initial begin
        Q=0;
    end
    always @(posedge CLK) begin
        Q<=D; 
    end
endmodule