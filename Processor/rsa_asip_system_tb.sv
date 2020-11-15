`timescale 1 ps / 1 ps
module rsa_asip_system_tb ();

logic clk, rst, selected, reg15,
h_sync, v_sync, clk_25mhz, sync_n, blank_n;
//logic [31:0] pc;
logic [7:0] rgb;

rsa_asip_system DUT
(.clk(clk), .rst(rst), .selected(selected), .reg15(reg15),
//);
.h_sync(h_sync), .v_sync(v_sync), .clk_25mhz(clk_25mhz), .sync_n(sync_n), .blank_n(blank_n),
.R(rgb), .G(), .B());


always #1 clk <= ~clk;

initial begin
	clk = 0;
	rst = 1;
	selected = 0;
	#3 rst = 0;
	selected = 1;
	@(posedge reg15);
	$finish;
end

//vsim -gui -l msim_transcript work.rsa_asip_system_tb -L altera_mf_ver -L altera_mf

endmodule 