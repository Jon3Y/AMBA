//ahb_slave_inf & sram_core;
module ahb_ctrl_top(
    //ahb input signals;
    hclk,
    hrstn,
    hsel,
    htrans,
    hsize,
    hburst,
    hwrite,
    haddr,
    hready_in,
    hwdata,

    //ahb output signals;
    hready_out,
    hresp,
    hrdata      
);

//input&output define;
input wire hclk;
input wire hrstn;
input wire hsel;
input wire [1:0] htrans;
input wire [2:0] hsize;
input wire [2:0] hburst;
input wire hwrite;
input wire [31:0] haddr;
input wire hready_in;
input wire [31:0] hwdata;
output wire hready_out;
output wire [1:0] hresp;
output wire [31:0] hrdata;

wire [7:0] sram_q0;
wire [7:0] sram_q1;
wire [7:0] sram_q2;
wire [7:0] sram_q3;
wire [7:0] sram_q4;
wire [7:0] sram_q5;
wire [7:0] sram_q6;
wire [7:0] sram_q7;
wire [3:0] bank0_csn;
wire [3:0] bank1_csn;
wire sram_we;
wire [12:0] sram_addr;
wire [31:0] sram_wdata;

//instance 8K*8 sram;
sram_core u_sram_core(
    .clk(hclk),
    .bank0_csn(bank0_csn),
    .bank1_csn(bank1_csn),
    .sram_we(sram_we),
    .sram_wdata(sram_wdata),
    .sram_addr(sram_addr),
    .sram_q0(sram_q0),
    .sram_q1(sram_q1),
    .sram_q2(sram_q2),
    .sram_q3(sram_q3),
    .sram_q4(sram_q4),
    .sram_q5(sram_q5),
    .sram_q6(sram_q6),
    .sram_q7(sram_q7)
);

//instance ahb_slave_inf;
ahb_slave_inf u_ahb_slave_inf(
    .hclk(hclk),
    .hrstn(hrstn),
    .hsel(hsel),
    .htrans(htrans),
    .hsize(hsize),
    .hburst(hburst),
    .hwrite(hwrite),
    .haddr(haddr),
    .hready_in(hready_in),
    .hwdata(hwdata),
    .hready_out(hready_out),
    .hresp(hresp),
    .hrdata(hrdata),
    .sram_q0(sram_q0),
    .sram_q1(sram_q1),
    .sram_q2(sram_q2),
    .sram_q3(sram_q3),
    .sram_q4(sram_q4),
    .sram_q5(sram_q5),
    .sram_q6(sram_q6),
    .sram_q7(sram_q7), 
    .bank0_csn(bank0_csn),
    .bank1_csn(bank1_csn),
    .sram_we(sram_we),
    .sram_addr(sram_addr),
    .sram_wdata(sram_wdata)          
);

endmodule