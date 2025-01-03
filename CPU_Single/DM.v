module DM(
    input [31:0] Addr,
    output reg [31:0] R_data,
    input [31:0] W_data,
    input R,
    input W
);
    reg [31:0] Mem[1023:0];
    initial begin
        Mem[0]=0;
        Mem[1]=1;
    end
    always @(*) begin
        if(R) R_data=Mem[Addr[9:0]];
    end
    always @(posedge W) begin
        if(W) Mem[Addr[9:0]]<=W_data;
    end
endmodule