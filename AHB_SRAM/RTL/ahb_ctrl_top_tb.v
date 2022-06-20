`timescale 1ns/1ns
module ahb_ctrl_top_tb;

reg hclk;
reg hrstn;
reg hsel;
reg [1:0] htrans;
reg [2:0] hburst;
reg [2:0] hsize;
reg hwrite;
reg [31:0] haddr;
reg [31:0] hwdata;
reg hready_in;
wire hready_out;
wire [1:0] hresp;
wire [31:0] hrdata;

//instance ahb_ctrl_top;
ahb_ctrl_top u_ahb_ctrl_top(
    .hclk(hclk),
    .hrstn(hrstn),
    .hsel(hsel),
    .htrans(htrans),
    .hburst(hburst),
    .hsize(hsize),
    .hwrite(hwrite),
    .haddr(haddr),
    .hwdata(hwdata),
    .hready_in(hready_in),
    .hready_out(hready_out),
    .hresp(hresp),
    .hrdata(hrdata)
);

initial hclk = 1'b0;
always #10 hclk = ~hclk;

initial begin
    hrstn = 1'b0;

    #20
    hrstn = 1'b1;
    hready_in = 1'b0;
    hsel = 1'b0;
    htrans = 2'b10;
    hburst = 3'd0;
    //32bit write;
    hsize = 3'b010;
    hwrite = 1'b1;
    haddr = 32'h1000_9fff;
    hwdata = 32'h1234_5678;

    //test hsel;
    #40
    hsel = 1'b1;
    //test hready;
    #40
    hready_in = 1'b1;
    #20
    hready_in = 1'b0;
    //8bit read;
    #40
    hready_in = 1'b1;
    hsize = 3'b000;
    hwrite = 1'b0;
    haddr = 32'h1000_9fff;
    //16bit read;
    #40
    hready_in = 1'b1;
    hsize = 3'b001;
    hwrite = 1'b0;
    haddr = 32'h1000_9fff;
    //32bit read;
    #40
    hready_in = 1'b1;
    hsize = 3'b010;
    hwrite = 1'b0;
    haddr = 32'h1000_9fff;
    #80
    $finish;
end

`ifdef USE_VERDI_SIM
initial begin
    $fsdbDumpfile("ahb_tb.fsdb");
    $fsdbDumpvars;
    end
`endif

endmodule