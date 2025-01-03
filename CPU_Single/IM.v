module IM(
    input [31:0] Addr,
    output reg [31:0] Inst
);
    reg [31:0] Mem[1023:0];
    initial begin
        // $readmemb("./program.txt",Mem);
        Mem[0]=32'b10001100000000010000000000000001;
        Mem[1]=32'b00000000001000100001100000100000;
        Mem[2]=32'b00000000001000100001100000100000;
        Mem[3]=32'b10101100000000010000000000000010;
        Mem[4]=32'b00001000000000000000000000000000;
    end
    always @(Addr) begin
        Inst=Mem[Addr[9:0]/4];
    end
endmodule