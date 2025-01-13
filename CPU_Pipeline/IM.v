module IM(
    input [31:0] Addr,
    output reg [31:0] Inst
);
	integer i;
    reg [31:0] Mem[1023:0];
    initial begin
        /* 
            init:
            reg[0] = 0 , reg[1] = 2 , reg[2] = 3
            mem[0] = 0 , mem[1] = 5 , mem[2] = 10
        */
		for(i=0;i<1024;i=i+1)Mem[i]=0;// nop
        Mem[0]=32'b10001100000000110000000000000001;// lw r3, 1(r0)
        Mem[1]=32'b10001100000001000000000000000010;// lw r4, 2(r0)
        //reg: 0, 2, 3, 5, 10
        Mem[2]=32'b00000000001000100010100000100000;// add r5, r1, r2
        //reg: 0, 2, 3, 5, 10, 5
        Mem[3]=32'b00010000011001010000000000010100;// beq r3, r5, 20
        // ...
        Mem[24]=32'b10101100000001010000000000000011;// sw r0, r5, 3
        //mem: 0, 5, 10, 5
        Mem[25]=32'b00001000000000000000000000000000;// j 0
    end
    always @(Addr) begin
        Inst=Mem[Addr[9:0]/4];
    end
endmodule