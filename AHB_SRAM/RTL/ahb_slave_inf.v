module ahb_slave_inf(
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
    hrdata,

    //sram_core output signals;
    sram_q0,
    sram_q1,
    sram_q2,
    sram_q3,
    sram_q4,
    sram_q5,
    sram_q6,
    sram_q7, 

    //sram_core contrl signals;
    bank0_csn,
    bank1_csn,
    sram_we,
    sram_addr,
    sram_wdata           
);

//htrans type;
parameter IDLE   = 0;
parameter BUSY   = 1;
parameter NONSEQ = 2;
parameter SEQ    = 3;

//hresp type;
parameter OKAY  = 0;
parameter ERROR = 1;
parameter RETRY = 2;
parameter SPLIT = 3;

//hsize type;
parameter BIT8  = 0;
parameter BIT16 = 1;
parameter BIT32 = 2;

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
input wire [7:0] sram_q0;
input wire [7:0] sram_q1;
input wire [7:0] sram_q2;
input wire [7:0] sram_q3;
input wire [7:0] sram_q4;
input wire [7:0] sram_q5;
input wire [7:0] sram_q6;
input wire [7:0] sram_q7;
output wire [3:0] bank0_csn;
output wire [3:0] bank1_csn;
output wire sram_we;
output wire [12:0] sram_addr;
output wire [31:0] sram_wdata;

reg [1:0] htrans_r;
reg [2:0] hsize_r;
reg [2:0] hburst_r;
reg hwrite_r;
reg [31:0] haddr_r;
wire sram_write;
wire sram_read;
wire sram_we;
wire sram_en;
wire [15:0] sram_addr_64k;
wire bank_sel;
wire [1:0] sram_bist_sel;
wire [1:0] hsize_sel;
reg [3:0] sram_csn;
 
//ahb slave cmd input;
always @(posedge hclk or negedge hrstn) begin
    if (!hrstn) begin
        htrans_r <= 2'd0;
        hsize_r <= 3'd0;
        hburst_r <= 3'd0;
        hwrite_r <= 1'b0;
        haddr_r <= 32'd0;
    end
    else if (hready_in&hsel) begin
        htrans_r <= htrans;
        hsize_r <= hsize;
        hburst_r <= hburst;
        hwrite_r <= hwrite;
        haddr_r <= haddr;
    end
    else begin
        htrans_r <= 2'd0;
        hsize_r <= 3'd0;
        hburst_r <= 3'd0;
        hwrite_r <= 1'b0;
        haddr_r <= 32'd0;
    end   
end

//sram_we&sram_en;
assign sram_write = (((htrans_r==SEQ)||(htrans_r==NONSEQ))&&(hwrite_r))?1'b1:1'b0;
assign sram_read = (((htrans_r==SEQ)||(htrans_r==NONSEQ))&&(!hwrite_r))?1'b1:1'b0;
assign sram_we = sram_write;
assign sram_en = (sram_write|sram_read); 

//haddr -> sram_addr;
assign sram_addr_64k = haddr_r[15:0];
assign sram_addr = haddr_r[14:2];

//bank sel & sram bist sel;
assign bank_sel = ((sram_en)&&(!sram_addr_64k[15]))?1'b1:1'b0;
assign bank0_csn = ((sram_en)&&(!sram_addr_64k[15]))?sram_csn:4'b1111;
assign bank1_csn = ((sram_en)&&(sram_addr_64k[15]))?sram_csn:4'b1111;
assign sram_bist_sel = sram_addr_64k[1:0];
assign hsize_sel = hsize_r[1:0];

//hsize 8/16/32bit -> sram_csn;
always @(*) begin
    if (hsize_sel==BIT32) begin
        sram_csn = 4'b0000;
    end
    else if (hsize_sel==BIT16) begin
        if (sram_bist_sel[1]) begin     //big_endian;
            sram_csn = 4'b1100;
        end
        else if (!sram_bist_sel[1]) begin
            sram_csn = 4'b0011;
        end
    end
    else if (hsize_sel==BIT8) begin
        case (sram_bist_sel)
            2'b11:      sram_csn = 4'b1110;
            2'b10:      sram_csn = 4'b1101;
            2'b01:      sram_csn = 4'b1011;
            2'b00:      sram_csn = 4'b0111;
            default:    sram_csn = 4'b1111;
        endcase
    end
    else begin
        sram_csn = 4'b1111;
    end
end

//data path;
assign sram_wdata = hwdata;
assign hrdata = (bank_sel)?{sram_q3, sram_q2, sram_q1, sram_q0}:{sram_q7, sram_q6, sram_q5, sram_q4};

//ahb cmd output;
assign hready_out = 1'b1;       //no delay;
assign hresp = OKAY;

endmodule