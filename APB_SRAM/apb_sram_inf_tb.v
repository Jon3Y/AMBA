`timescale 1ns/1ns
module apb_sram_inf_tb;

reg clk;
reg rstn;
reg psel;
reg penable;
reg [9:0] paddr;
reg pwrite;
reg [31:0] pwdata;
wire pready;
wire [31:0] prdata;

apb_sram_inf u_apb_sram_inf(
    .clk(clk),
    .rstn(rstn),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .pready(pready),
    .prdata(prdata)
);

initial clk = 1'b0;
always #10 clk = ~clk;

initial begin
    rstn = 1'b0;
    #20
    rstn = 1'b1;
    psel = 1'b0;
    penable= 1'b0;

    //write;
    #10
    psel = 1'b1;
    paddr = 12'hff1;
    pwrite = 1'b1;
    pwdata = 32'hffff_ff01;
    #20
    penable = 1'b1;
    #20
    penable = 1'b0;
    psel = 1'b0;

    //read;
    #20
    psel = 1'b1;
    paddr = 12'hff1;
    pwrite = 1'b0;
    //pwdata = 32'bffff_ff01;
    #20
    penable = 1'b1;
    #20
    penable = 1'b0;
    psel = 1'b0;

    #40
    $finish;
end

`ifdef USE_VERDI_SIM
initial begin
    $fsdbDumpfile("apb_sram_inf_tb");
    $fsdbDumpvars;
    end
`endif

endmodule