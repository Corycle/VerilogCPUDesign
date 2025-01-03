module RF(
    input CLK,
    input W,
    input [4:0] R_reg1,
    input [4:0] R_reg2,
    output reg [31:0] R_data1,
    output reg [31:0] R_data2,
    input [4:0] W_reg,
    input [31:0] W_data
);
    integer i;
    reg [31:0] Reg[31:0];
    initial begin
        for(i=0;i<32;i=i+1)Reg[i]=0;
    end
    always @(posedge CLK) begin
        if(W) Reg[W_reg]=W_data;
    end
    always @(*) begin
        R_data1=Reg[R_reg1];
        R_data2=Reg[R_reg2];
    end
endmodule