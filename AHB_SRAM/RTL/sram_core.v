//sram_bank0 & sram_bank1;
//64K = 8k*4 + 8K*4;
module sram_core(
    clk,
    bank0_csn,
    bank1_csn,
    sram_we,
    sram_wdata,
    sram_addr,
    sram_q0,
    sram_q1,
    sram_q2,
    sram_q3,
    sram_q4,
    sram_q5,
    sram_q6,
    sram_q7,  
);

input wire clk;
input wire [3:0] bank0_csn;
input wire [3:0] bank1_csn;
input wire sram_we;
input wire [31:0] sram_wdata;
input wire [12:0] sram_addr;
output wire [7:0] sram_q0;
output wire [7:0] sram_q1;
output wire [7:0] sram_q2;
output wire [7:0] sram_q3;
output wire [7:0] sram_q4;
output wire [7:0] sram_q5;
output wire [7:0] sram_q6;
output wire [7:0] sram_q7;

//instance sram_bank0;
sram_bist u0_sram_bist(
    .clk(clk),
    .csn(bank0_csn[0]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[7:0]),
    .dout(sram_q0)
);
sram_bist u1_sram_bist(
    .clk(clk),
    .csn(bank0_csn[1]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[15:8]),
    .dout(sram_q1)
);
sram_bist u2_sram_bist(
    .clk(clk),
    .csn(bank0_csn[2]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[23:16]),
    .dout(sram_q2)
);
sram_bist u3_sram_bist(
    .clk(clk),
    .csn(bank0_csn[3]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[31:24]),
    .dout(sram_q3)
);

//instance sram_bank1;
sram_bist u4_sram_bist(
    .clk(clk),
    .csn(bank1_csn[0]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[7:0]),
    .dout(sram_q4)
);
sram_bist u5_sram_bist(
    .clk(clk),
    .csn(bank1_csn[1]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[15:8]),
    .dout(sram_q5)
);
sram_bist u6_sram_bist(
    .clk(clk),
    .csn(bank1_csn[2]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[23:16]),
    .dout(sram_q6)
);
sram_bist u7_sram_bist(
    .clk(clk),
    .csn(bank1_csn[3]),
    .we(sram_we),
    .addr(sram_addr[9:0]),
    .din(sram_wdata[31:24]),
    .dout(sram_q7)
);

endmodule