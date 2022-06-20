//single port sram; 
//8K = 8bit * 1024;
module sram_bist(
    clk,
    csn,
    we,
    addr,
    din,
    dout
);

parameter mem_depth = 1024;
parameter mem_width = 8;
parameter mem_bitw = 10;

input wire clk;
input wire csn;
input wire we;
input wire [mem_bitw-1:0] addr;
input wire [mem_width-1:0] din;
output reg [mem_width-1:0] dout;

reg [mem_width-1:0] mem[0:mem_depth-1];

always @(posedge clk) begin
    if (!csn) begin
        if (we) begin
            mem[addr] <= din;
        end
        else begin
            dout <= mem[addr];
        end
    end          
end

endmodule