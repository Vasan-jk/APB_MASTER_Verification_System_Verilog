`include "defines.svh"
interface intf(input PCLK, PRESETn);
logic [`DATA_WIDTH-1:0] PRDATA;
logic PREADY;
logic PSLVERR;
logic transfer;
logic write_read;
logic [`ADDR_WIDTH-1:0]addr_in;
logic [`DATA_WIDTH-1:0]wdata_in;
logic [`DATA_WIDTH/8 - 1:0]strb_in;
logic [`ADDR_WIDTH] PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
logic [`DATA_WIDTH-1:0]PWDATA;
logic [`DATA_WIDTH/8 -1:0]PSTRB;
logic [`DATA_WIDTH-1:0] rdata_out;
logic transfer_done;
logic error;

clocking drv_cb @(posedge PCLK);
default input #1 output #0;
output PRDATA, PREADY, PSLVERR, transfer, write_read, addr_in, wdata_in, strb_in;
input PADDR, PSEL,PENABLE, PWRITE, PWDATA, PSTRB, rdata_out, transfer_done, error;
endclocking

clocking mon_cb @(posedge PCLK);
default input #1 output #0;
input PRDATA, PREADY, PSLVERR, transfer, write_read, addr_in, wdata_in, strb_in;
input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB, rdata_out, transfer_done, error;
endclocking

modport drv(clocking drv_cb, input PRESETn);
modport mon(clocking mon_cb, input PRESETn);

endinterface
