//`include "defines.svh"
class transaction;
rand bit PREADY;
rand bit PSLVERR;
rand bit transfer;
rand bit write_read;
rand bit [`ADDR_WIDTH-1:0]addr_in;
rand bit [`DATA_WIDTH-1:0]wdata_in;
rand bit [`DATA_WIDTH/8 - 1:0]strb_in;
rand bit [`DATA_WIDTH-1:0] PRDATA;
bit [`ADDR_WIDTH-1:0] PADDR;
bit PSEL;
bit PWRITE;
bit PENABLE;
bit [`DATA_WIDTH-1:0]PWDATA;
bit [`DATA_WIDTH/8 -1:0]PSTRB;
bit [`DATA_WIDTH-1:0] rdata_out;
bit transfer_done;
bit error;
int wait_state;
constraint w{
	wait_state == 0;
	}
constraint base{
	PREADY == 1;
	//soft transfer == 1;
	//write_read == 1;
	strb_in == 4'b1111;
	PSLVERR == 0;
}
endclass


class writ_check extends transaction;
//int tmp = 0;
constraint write{
    write_read ==1;
    //transfer inside {0,1};

}
//function void post_randomize();
//  tmp = transfer;
//endfunction
endclass

class rd_check extends transaction;
constraint read{
    write_read == 0;
}
endclass
class b2b_wr extends transaction;
constraint write{
    write_read ==1;
}
endclass

class b2b_rd extends transaction;
constraint read{
    write_read == 0;
}
endclass
 
