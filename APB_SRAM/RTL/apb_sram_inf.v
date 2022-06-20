//APB spsram slave inf;
module apb_sram_inf(
    clk,
    rstn,
    psel,
    penable,
    paddr,
    pwrite,
    pwdata,
    pready,
    prdata
);

parameter mem_depth = 1024;
parameter mem_width = 32;
parameter mem_bitw = 10;

parameter IDEL = 0;
parameter SETUP = 1;
parameter ENABLE = 2;

input wire clk;
input wire rstn;
input wire psel;
input wire penable;
input wire [mem_bitw+1:0] paddr;        //byte address;
input wire pwrite;
input wire [31:0] pwdata;
output wire pready;
output reg [31:0] prdata;

reg [1:0] sta;
reg [1:0] nsta;
reg apb_write;
reg apb_read;
reg pready_pre;
reg [mem_bitw-1:0] apb_addr;
reg [31:0] apb_wdata;

wire mem_cs;
wire mem_we;
wire [mem_width-1:0] mem_dout;

//fsm;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        sta = 2'd0;
    end
    else begin
        sta = nsta;
    end
end

//state transition;
always @(*) begin
    nsta = sta;
    case (sta) 
        IDEL: begin
            if ((psel==1'b1) && (penable==1'b0)) begin
                nsta = SETUP;
            end
            else begin
                nsta = IDEL;
            end
        end
        SETUP: begin
            if ((psel==1'b1) && (penable==1'b1)) begin
                nsta = ENABLE;
            end
            else begin
                nsta = IDEL;
            end
        end
        ENABLE: begin
            if ((psel==1'b1) && (penable==1'b1)) begin
                nsta = ENABLE;
            end
            else begin
                nsta = IDEL;
            end
        end
        default: begin
            nsta <= IDEL;
        end
    endcase
end

//fsm output;
always @(*) begin
    if (sta==IDEL) begin
        apb_write = 1'b0;
        apb_read = 1'b0;
        pready_pre = 1'b0;
    end
    else if (sta==SETUP) begin
        apb_addr = paddr[mem_bitw+1:2];
        if (pwrite) begin
            apb_write = 1'b1;
            apb_read = 1'b0;
            apb_wdata = pwdata;
            pready_pre = 1'b0;
        end
        else if (!pwrite) begin
            apb_write = 1'b0;
            apb_read = 1'b1;
            pready_pre = 1'b0;
        end
    end
    else if (sta==ENABLE) begin
        if (pwrite) begin
            pready_pre = 1'b1;
        end 
        else if (!pwrite) begin
            prdata = mem_dout;
            pready_pre = 1'b1;
        end
    end
end

assign pready = pready_pre;                 //apb trans done;
assign mem_cs = (apb_write | apb_read);     //sram cs;
assign mem_we = apb_write;                  //sram we;

spsram u_spsram(
    .clk(clk),
    .cs(mem_cs),
    .we(mem_we),
    .addr(apb_addr),
    .din(apb_wdata),
    .dout(mem_dout)
);

endmodule